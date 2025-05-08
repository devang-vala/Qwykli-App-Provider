import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/constants/app_data.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/ui/widget/select_service_widegt.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 63, 164),
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: GestureDetector(
            onTap: () {
              CustomNavigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          "Add Services",
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SelectServicesWidget(categoryToServices: AppData.categoryToServices,),

        ),
      ),
    );
  }
}
