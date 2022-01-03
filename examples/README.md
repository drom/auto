# Examples

### Quadrature encoder FSM

```js
{
  clock: 'clk',
  asyncReset: '~reset_n',
  cond: '{a, b}',
  draw: 'circo', // circo, dot
  ascii: true,
  states: {
    s00: {s01: "2'b01", s10: "2'b10", err: "2'b11"},
    s01: {s11: "2'b11", s00: "2'b00", err: "2'b10"},
    s11: {s10: "2'b10", s01: "2'b01", err: "2'b00"},
    s10: {s00: "2'b00", s11: "2'b11", err: "2'b01"},
    err: {}
  }
}
```

![](quadrature.v0.svg)

In Verilog: [quadrature.v](quadrature.v#L7-L20)

### JTAG FSM

```js
{
  name: 'J',
  cond: 'tms',
  clock: 'tck',
  syncReset: 'treset',
  states: [
    // skewers
    {name: 'testLogicReset', next: {runTest: 0}},
    {name: 'runTest'},

    {name: 'selectDR',  next: {captureDR: 0}},
    {name: 'captureDR', next: {shiftDR:   0}},
    {name: 'shiftDR',   next: {exit1DR:   1}},
    {name: 'exit1DR',   next: {pauseDR:   0}},
    {name: 'pauseDR',   next: {exit2DR:   1}},
    {name: 'exit2DR',   next: {updateDR:  1}},
    'updateDR',

    {name: 'selectIR',  next: {captureIR: 0}},
    {name: 'captureIR', next: {shiftIR:   0}},
    {name: 'shiftIR',   next: {exit1IR:   1}},
    {name: 'exit1IR',   next: {pauseIR:   0}},
    {name: 'pauseIR',   next: {exit2IR:   1}},
    {name: 'exit2IR',   next: {updateIR:  1}},
    'updateIR',

    // bridge
    {name: 'runTest',   next: {selectDR:       1}},
    {name: 'selectDR',  next: {selectIR:       1}},
    {name: 'selectIR',  next: {testLogicReset: 1}},

    // DR
    {name: 'captureDR', next: {exit1DR:  1}},
    {name: 'exit1DR',   next: {updateDR: 1}},
    {name: 'exit2DR',   next: {shiftDR:  0}},
    {name: 'updateDR',  next: {runTest:  0, selectDR: 1}},

    // IR
    {name: 'captureIR', next: {exit1IR:  1}},
    {name: 'exit1IR',   next: {updateIR: 1}},
    {name: 'exit2IR',   next: {shiftIR:  0}},
    {name: 'updateIR',  next: {runTest: 0, selectIR: 1}}
  ]
}
```
![](jtag.v0.svg)

In Verilog: [jtag.v](jtag.v#L6-L49)
