import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './appwrite-sdk.dart' as sdk;

const access_key = "ca39f98b01df960c01efdf1520609537";

http.Client? _httpClient;

http.Client get httpClient => _httpClient ?? http.Client();

set httpClient(http.Client client) => _httpClient = client;

Future<dynamic> main(final context) async {

  context.log("version: 0.6");

  final requestBody = context.req.body;

  final String apiKey = requestBody['apiKey'];
  await sdk.init(apiKey);

  if (context.req.path == '/eur') {
    final amountInEuros = double.parse(context.req.query['amount']);
    final response = await httpClient.get(Uri.parse('http://api.exchangerate.host/live?source=EUR&currencies=USD&access_key=$access_key'));
    final data = json.decode(response.body);
    final amountInDollars = amountInEuros * data['quotes']['EURUSD'];
    return context.res.send(amountInDollars.toStringAsFixed(2));
  }

  if (context.req.path == '/inr') {
    final amountInRupees = double.parse(context.req.query['amount']);
    final response = await httpClient.get(Uri.parse('http://api.exchangerate.host/live?source=INR&currencies=USD&access_key=$access_key'));
    final data = json.decode(response.body);
    final amountInDollars = amountInRupees * data['quotes']['INRUSD'];
    return context.res.send(amountInDollars.toStringAsFixed(2));
  }

  return context.res.json({
          'ok': false, 
          'message': 'Invalid currency ${context.req.path}.'
        }, 400);
}


