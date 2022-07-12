import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as ioh;

void main(List<String> arguments) async {
  final pfx = File('assets/certificado.pfx').readAsBytesSync();
  final context = SecurityContext(withTrustedRoots: true)
    ..useCertificateChainBytes(pfx, password: '08081988')
    ..usePrivateKeyBytes(pfx, password: '08081988');

  String soap = '''<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <nfeDadosMsg xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4"><consStatServ xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00"><tpAmb>1</tpAmb><cUF>42</cUF><xServ>STATUS</xServ></consStatServ></nfeDadosMsg>
  </soap12:Body>
</soap12:Envelope>''';

  final ioClient = ioh.IOClient(HttpClient(context: context));

  http.Response response = await ioClient.post(
    Uri.parse(
        'https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx'),
    headers: {
      'content-type': 'application/soap+xml; charset=utf-8',
    },
    body: soap,
  );
  print(response.statusCode);
}
