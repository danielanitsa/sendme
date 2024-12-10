import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('${dotenv.env['PROJECT_ID']}');
final account = Account(client);
