'use strict';

const IDENTITY = Symbol('proxy_target_identity');

const get = (target, prop) => {
  if (prop === IDENTITY) {
    return target;
  }
  if (!(prop in target.defo)) {
    target.defo[prop] = {type: 'Int', __ID__: prop, ref: target}; // empty object
  }
  return target.defo[prop];
};

const set = (target, prop, value) => {

  if (typeof value === 'number') {
    value = {op: 'literal', value, w: Math.ceil(Math.log2(value + 1))};
  } else if (Array.isArray(value)) {
    value = {op: 'op', items: value};
  } else if (typeof value !== 'object') {
    throw new Error('Unexpected type: ' + (typeof value) + ' of RHS: ' + value);
  }

  value.__ID__ = prop;
  value.ref = target;

  let def = target.defo[prop];

  if (def === undefined) {
    target.defo[prop] = def = {ref: target};
    // return true;
  }

  if (typeof def !== 'object') {
    throw new Error('unexpected type: ' + (typeof def) + ' of "defo" entry: ' + prop);
  }

  Object.assign(def, value, {ref: target});

  if (value.op !== undefined) {
    target.items.push(def);
  }

  return true;
};

const createModule = id => {
  const obj = {
    kind: 'module',
    __ID__: id,
    defo: {},
    ins: [],
    items: []
  };
  const prx = new Proxy(obj, {get, set});
  return [obj, prx];
};

const updateGraph = (m) => {
  Object.entries(m.defo).map(([, val]) => {
    if (!val.items) {
      val.items = [];
    }
  });
  Object.entries(m.defo).map(([, val]) => {
    const consumers = [];
    Object.entries(m.defo).map(([, val1]) => {
      val1.items.map((item) => {
        if (item === val) {
          consumers.push(val1);
        }
      });
    });
    val.consumers = consumers;
  });
};

const indent = arr => arr.map(e => '  ' + e);

const edgeBufferCtrl = (edge) => {
  const id = edge.__ID__;
  if (!edge.d) {
    return [
      '// buff(0)',
      `wire ${id}_m_ack;`,
      `wire ${id}_m_req = ${id}_req;`,
      `assign ${id}_ack = ${id}_m_ack;`
    ];
  }
  if (edge.d === 1) {
    return [
      '// buff(1)',
      `wire ${id}_m_ack;`,
      `reg ${id}_m_req;`,
      `assign ${id}_ack = ~${id}_m_req | ${id}_m_ack;`,
      `assign ${id}_en = ${id}_req & ${id}_ack;`,
      `always @(posedge clock or negedge reset_n) if (~reset_n) ${id}_m_req <= 1'b0; else ${id}_m_req <= ~${id}_ack | ${id}_req;`
    ];
  }
  return [`// buff(${edge.d}) TODO`];
};

const edgeForkCtrl = (edge) => {
  const id = edge.__ID__;
  const targets = edge.consumers;
  return [
    ...((targets.length > 1) ? [
      `// fork(${targets.length})`,
      `reg ${targets.map((e, ei) => `${id}_r_${ei}_ack`).join(', ')};`,
      ...targets.map((e, ei) => `assign ${id}_${ei}_req = ${id}_m_req & ~${id}_r_${ei}_ack;`),
      ...targets.map((e, ei) => `wire ${id}_s_${ei}_ack = ${id}_${ei}_ack | ~${id}_${ei}_req;`),
      `assign ${id}_m_ack = ${targets.map((e, ei) => `${id}_s_${ei}_ack`).join(' & ')};`,
      ...targets.map((e, ei) => `always @(posedge clock or negedge reset_n) if (~reset_n) ${id}_r_${ei}_ack <= 1'b0; else ${id}_r_${ei}_ack <= ${id}_s_${ei}_ack & ~${id}_m_ack;`),
    ] : [
      `// fork(${targets.length})`,
      `assign ${id}_m_ack = ${id}_0_ack;`,
      `assign ${id}_0_req = ${id}_m_req;`
    ])
  ];
};

const nodeMimoCtrl = (edge) => {
  const id = edge.__ID__;
  return [
    '// join(' + edge.items.length + ')',
    'assign ' + id + '_req = ' + edge.items
      .map((item) =>
        item.__ID__ + '_' + item.consumers.findIndex(e => e === edge) + '_req'
      ).join(' & ') + ';',
    ...edge.items.map((item) =>
      'assign '
      + item.__ID__ + '_' + item.consumers.findIndex(e => e === edge)
      + '_ack = ' + edge.items
        .map((item1) => (item === item1) ? id + '_ack' : item1.__ID__ + '_req')
        .join(' & ') + ';')
  ];
};

const wrapper = (prefix, names) => {
  if (names.length === 0) {
    return '';
  }
  let res = prefix;
  let len = res.length;
  names.map((name) => {
    const len1 = len + 1 + name.length;
    if (len1 > 80) {
      res += '\n ';
      len = name.length;
    }
    res += ' ' + name;
    len += 1 + name.length;
  });
  return res;
};

const joiner = (sep1, sep2) => (e, i, arr) =>
  e + ((i === (arr.length - 1)) ? sep2 : sep1);

const modWires = (mod) => {
  const pub = [], priv = [];
  Object.entries(mod.defo).flatMap(([key, edge]) => {
    (edge.items.length ? priv : pub).push(key + '_req', key + '_ack');
    if (edge.consumers.length) {
      priv.push(
        ...edge.consumers.flatMap((e, ei) =>
          [key + '_' + ei + '_req', key + '_' + ei + '_ack'])
      );
    } else {
      pub.push(key + '_0_req', key + '_0_ack');
    }
    if (edge.d === 1) {
      pub.push(key + '_en');
    }
  });
  return {pub, priv};
};

const renderVerilog = (m) => {
  const {pub, priv} = modWires(m);
  // console.log(m);
  return [
    wrapper('wire', pub.map(joiner(',', ';'))),
    'begin : ' + m.__ID__ + '_block',
    ...indent([
      wrapper('wire', priv.map(joiner(',', ';'))),
      ...Object.entries(m.defo).flatMap(([, edge]) => [
        `begin : ${edge.__ID__}_edge_block`,
        ...indent([
          ...edgeBufferCtrl(edge),
          ...edgeForkCtrl(edge)
        ]),
        `end : ${edge.__ID__}_edge_block`
      ]),
      ...Object.entries(m.defo).flatMap(([, edge]) =>
        (!edge.items.length) ? [] : [
          `begin : ${edge.__ID__}_node_block`,
          ...indent(nodeMimoCtrl(edge)),
          `end : ${edge.__ID__}_node_block`
        ]
      )
    ]),
    'end : ' + m.__ID__ + '_block'
  ].join('\n');
};

function reqack (fn, blockName) {
  const [obj, prx] = createModule(blockName || 'mod');
  fn(prx);
  updateGraph(obj);
  return renderVerilog(obj);
}

module.exports = reqack;
