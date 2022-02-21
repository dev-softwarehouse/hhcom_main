import 'package:get/get.dart';
import 'package:hhcom/Models/model.dart';

class WorkerController extends GetxController {
  var selectedWorker = WorkerModel().obs;
  var workerList = <WorkerModel>[].obs;

  setSelectedCustomer(WorkerModel? workerModel) {
    selectedWorker.value = workerModel!;
  }
}
