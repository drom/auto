'use strict';

function reqack () {
  const res = [];
  for (const arg of arguments) {
    let [ts, is] = arg;
    if (!Array.isArray(ts)) {
      ts = [ts];
    }
    if (!Array.isArray(is)) {
      is = [is];
    }
    if ((ts.length === 1) & (is.length > 1)) {
      const t = ts[0];
      res.push(
        `// fork: ${is.length}`,
        `reg ${is.map(i => `${i}_reg`).join(', ')};`,
        ...is.map(i => `assign ${i}_req = ${t}_req & ~${i}_reg;`),
        ...is.map(i => `wire ${i}_ackg = ${i}_ack | ~${i}_req;`),
        `assign ${t}_ack = ${is.map(i => `${i}_ackg`).join(' & ')};`,
        ...is.map(i => `always @(posedge clock or negedge reset_n) if (~reset_n) ${i}_reg <= 1'b0; else ${i}_reg <= ${i}_ackg & ~${t}_ack;`)
      );
    } else if ((ts.length > 1) & (is.length === 1)) {
      const i = is[0];
      res.push(
        `// join: ${ts.length}`,
        `assign ${i}_req = ${ts.map(t => `${t}_req`).join(' & ')};`,
        ...ts.map((t, ti) =>
          `assign ${t}_ack = ${ts.map((te, tj) =>
            (ti === tj) ? i + '_ack' : te + '_req').join(' & ')};`)
      );
    }
  }
  return res.join('\n');
}

module.exports = reqack;
