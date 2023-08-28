// ignore_for_file: deprecated_member_use, unused_local_variable, await_only_futures, avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:path_provider/path_provider.dart';

class S3Handler {
  ///
  /// Upload a given file from Local storage to AWS S3. The File can have any of
  /// Guest/Private/Protected access levels.
  ///
  static Future<void> uploadFile({
    required String filePath,
    required StorageAccessLevel accessLevel,
  }) async {
    print(filePath);
    final file = File(filePath);
    final key = file.path.split("/").last;
    print({key, accessLevel});

    // Set options
    final options = S3UploadFileOptions(
      accessLevel: accessLevel,
      metadata: <String, String>{
        'project': 'Amplify-for-Flutter',
      },
    );

    try {
      final S3UploadDataResult result = (await Amplify.Storage.uploadFile(
          localFile: file as AWSFile,
          key: key,
          options: options)) as S3UploadDataResult;
      print(result);
    } on StorageException catch (storageException) {
      print(storageException);
      throw (storageException);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  ///
  /// Download a given object from S3 to local storage.
  ///
  /// It seems the "key" is looked up in "public" prefix in the bucket.
  /// The role associated with Identity Pool should have required policy to allow
  /// GetObject from this path.
  ///
  static Future<void> downloadFile(String key) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = "${documentsDir.path}/$key";
    final file = File(filepath);

    try {
      await Amplify.Storage.downloadFile(key: key, localFile: file as AWSFile);
    } on StorageException catch (e) {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  ///
  /// Read S3 Bucket and return the object names.
  /// The returned Images will be downloaded to "Application Document" directory
  /// later. so, create the local paths for all these objects.
  ///
  /// Note: It seems there is no way to specify the S3 bucket to read from. By
  /// default, the bucket to be read from is taken from "amplifyconfiguration.dart"
  /// file. I tried to specify "path" parameter to "list". It's failing.
  ///
  /// Since the default access level is "guest", by default this API reads from
  /// "<bucket>/public" folder. So basically, all the objects returned are from
  /// this prefix.
  ///
  /// Also note that, the Authenticated Role associated with the Identity Pool
  /// should have required policy to List/Get Object from this bucket.
  ///
  static Future<List<String>> listItems() async {
    List<String> objects = [];

    try {
      final S3ListResult result =
          (await Amplify.Storage.list()) as S3ListResult;
      final documentsDir = await getApplicationDocumentsDirectory();
      result.items.forEach((e) => objects.add('${documentsDir.path}/${e.key}'));
      return objects;
    } on StorageException catch (e) {
      throw (e);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteFile() async {
    try {
      final RemoveResult result =
          (await Amplify.Storage.remove(key: 'ExampleKey')) as RemoveResult;
      print('Deleted file: ${result.key}');
    } on StorageException catch (e) {
      print('Error deleting file: $e');
    }
  }
}

class RemoveResult {
  get key => null;
}
