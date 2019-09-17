class AddressParams {
  static String network(Network network) {
    switch (network) {
      case Network.testnet:
        return "ckt";
      case Network.mainnet:
      default:
        return "ckb";
    }
  }

  static Network parseNetwork(String address) {
    return address.startsWith('ckb') ? Network.mainnet : Network.testnet;
  }

  static String formatType(FormatType formatType) {
    switch (formatType) {
      case FormatType.fullData:
        return '02';
      case FormatType.fullType:
        return '04';
      case FormatType.short:
      default:
        return '01';
    }
  }

  static String codeHashIndex(CodeHashIndex index) {
    switch (index) {
      case CodeHashIndex.ripemd160:
        return "01";
      case CodeHashIndex.blake160:
      default:
        return "00";
    }
  }
}

enum Network { mainnet, testnet }

enum FormatType { short, fullData, fullType }

enum CodeHashIndex { blake160, ripemd160 }
