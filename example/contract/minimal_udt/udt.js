
var ret = CKB.CODE.INDEX_OUT_OF_BOUND;

function is_issuer() {
  var first_input = CKB.load_input(0, 0, CKB.SOURCE.INPUT);
  if (typeof first_input === "number") {
    throw "Cannot fetch the first input";
  }
  var input_hex = Array.prototype.map.call(
    new Uint8Array(first_input),
    function(x) { return ('00' + x.toString(16)).slice(-2); }).join('');

  return input_hex !== undefined
}

function udt_amount(source) {
  var buffer = new ArrayBuffer(4);
  var index = 0;
  var total = 0;
  while (true) {
    ret = CKB.raw_load_cell_data(buffer, 0, index, source);
    if (ret === CKB.CODE.INDEX_OUT_OF_BOUND) {
      break;
    }
    if (ret !== 4) {
      throw "Invalid cell!";
    }
    var view = new DataView(buffer);
    total += view.getUint32(0, true);
    index += 1;
  }
  return total;
}

if (!is_issuer('0x36c329ed630d6ce750712a477543672adab57f4c') && udt_amount(CKB.SOURCE.GROUP_INPUT) !== udt_amount(CKB.SOURCE.GROUP_OUTPUT)) {
  throw "Invalid udt cell"
}