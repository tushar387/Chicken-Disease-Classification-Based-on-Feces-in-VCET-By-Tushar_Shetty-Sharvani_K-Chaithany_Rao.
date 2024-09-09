import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  File? _pickedImage;
  List<dynamic>? _prediction;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Chicken Disease Classification",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: _pickedImage == null && _prediction == null
          ? const Center(
              child: Text(
                "Select or Take an image",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            )
          : FutureBuilder<void>(
              future: Future.delayed(
                  const Duration(seconds: 1)), // Add a 2-second delay
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show circular progress indicator while waiting
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _pickedImage == null
                              ? Container()
                              : Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Image.file(
                                            _pickedImage!,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _pickedImage = null;
                                            _prediction = null;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 20),
                          if (_prediction != null &&
                                  double.parse(_prediction![0]["confidence"]
                                          .toStringAsFixed(1)) >=
                                      0.5 ||
                              _prediction![0]["label"] == "New Castle Disease")
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Status: ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                    Text(
                                      '${_prediction![0]["label"]}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                _getDescription(
                                    _prediction![0]["label"], context),
                              ],
                            )
                          else
                            const Text(
                              "Can't determine disease with confidence",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _optionDialogBox,
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.image,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget salmonellaSymptoms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Symptoms:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        _buildSymptomItem('Weak and lethargic birds.'),
        _buildSymptomItem('Very loose yellow or green droppings.'),
        _buildSymptomItem('Purple or blue looking comb and wattles.'),
        _buildSymptomItem('Decreased feeding and weight loss.'),
        _buildSymptomItem('Increased water consumption.'),
        _buildSymptomItem('Reduced egg production.'),
        _buildSymptomItem('Noticeably lower hatch rates.'),
        _buildSymptomItem(
            'Chicks and poults show weakness, anorexia, and shivering.'),
        SizedBox(height: 20),
        Text(
          'Description:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Salmonella infection in chickens can cause various symptoms, including weakness, diarrhea, purple or blue discoloration of the comb and wattles, decreased feeding, and reduced egg production. It is also a zoonotic pathogen, meaning it can be transmitted to humans.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        Text(
          'Treatment:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        _buildTreatmentItem('Laboratory Testing'),
        _buildTreatmentItem('Veterinary Examination and Advice'),
        _buildTreatmentItem('Use Oxytetracycline and neomycin.'),
        SizedBox(height: 20),
        Text(
          'Prevention:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        _buildPreventionItem('Good Hygiene Practices'),
        _buildPreventionItem('Vaccination'),
        _buildPreventionItem('Quarantine and Isolation'),
      ],
    );
  }

// Widget _buildSymptomItem(String symptom) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 5.0),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(
//           Icons.check_circle,
//           color: Colors.green,
//           size: 20,
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             symptom,
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//       ],
//     ),
//   );
// }

  Widget _buildSymptomItem(String symptom) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              symptom,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  ///

  Widget coccidiosisInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Description',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Coccidiosis is a common and deadly intestinal disease that affects many chickens. It is caused by a microscopic protozoan parasite that attaches itself to the intestinal lining of a chicken.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Text(
          'Symptoms:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        _buildSymptomItem('Inconsistence in laying eggs'),
        _buildSymptomItem('Diarrhea'),
        _buildSymptomItem('Pale skin and comb'),
        _buildSymptomItem('Lack of vigor'),
        _buildSymptomItem('Weight loss in older chickens'),
        _buildSymptomItem('Ruffled feathers'),
        _buildSymptomItem('Loss of appetite'),
        SizedBox(height: 10),
        Text(
          'Treatment:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        _buildTreatmentItem('Use Amprolium'),
        _buildTreatmentItem('Perform a complete change of bedding'),
        _buildTreatmentItem(
            'Empty and disinfect the feeders and water dispensers'),
        SizedBox(height: 10),
        Text(
          'Prevention:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        _buildPreventionItem('Keep the surroundings dry'),
        _buildPreventionItem('Quarantine new birds'),
        _buildPreventionItem('Provide clean bedding'),
      ],
    );
  }

// Widget _buildSymptomItem(String symptom) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 5.0),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(
//           Icons.check_circle,
//           color: Colors.green,
//           size: 20,
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             symptom,
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//       ],
//     ),
//   );
// }

  Widget _buildTreatmentItem(String treatment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.medical_services,
            color: Colors.blue,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              treatment,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreventionItem(String prevention) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield,
            color: Colors.orange,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              prevention,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  ///
  Future<void> _optionDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (_pickedImage != null && _prediction != null) {
                      setState(() {
                        _pickedImage = null;
                        _prediction = null;
                      });
                    }
                    _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Take a Picture",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                GestureDetector(
                  onTap: () {
                    if (_pickedImage != null && _prediction != null) {
                      setState(() {
                        _pickedImage = null;
                        _prediction = null;
                      });
                    }
                    _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Select an image ",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
    );

    setState(() {
      _prediction = output;
    });
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/tflite_model/kheva4.tflite',
      labels: 'assets/tflite_model/labels.txt',
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source);

    if (image == null) return;

    setState(() {
      _pickedImage = File(image.path);
    });

    classifyImage(_pickedImage!);
  }

  Widget _getDescription(String disease, BuildContext context) {
    String description = '';
    String solution = '';
    switch (disease) {
      case 'Coccidiosis':
        description =
            'Coccidiosis is a parasitic disease that affects the intestinal tract of chickens. It can cause diarrhea, weight loss, and decreased egg production.';

        solution =
            'To treat coccidiosis, you can administer coccidiostats or anticoccidial medications. Additionally, maintain proper hygiene and cleanliness in the chicken coop to prevent the spread of the disease.';
        break;
      case 'Healthy':
        description = 'Your chicken is healthy!';
        solution = 'Keep up with regular health checks and proper nutrition.';
        break;
      case 'New Castle Disease':
        description =
            'Newcastle disease is a contagious viral disease that affects many bird species, including chickens. Symptoms include respiratory distress, nervous signs, and sudden death.';
        solution =
            'There is no specific treatment for Newcastle disease. Prevention through vaccination and biosecurity measures is essential to control the spread of the virus.';
        break;
      case 'Salmonella':
        description =
            'Salmonella infection in chickens can cause diarrhea, lethargy, and decreased egg production. It is also a zoonotic pathogen, meaning it can be transmitted to humans.';
        solution =
            'To control salmonella infection, maintain good hygiene practices, provide clean water and feed, and avoid overcrowding in the coop. Additionally, handle eggs properly to reduce the risk of transmission to humans.';
        break;
      default:
        description = 'No description available.';
        solution = 'Please consult a veterinarian for further assistance.';
    }

    return disease == 'Salmonella'
        ? Padding(
            padding: const EdgeInsets.all(11.0),
            child: salmonellaSymptoms(),
          )
        : disease == 'Coccidiosis'
            ? Padding(
                padding: const EdgeInsets.all(11.0),
                child: coccidiosisInfo(),
              )
            : disease == 'New Castle Disease'
                ? Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: newCastleDiseaseSymptoms(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Description:',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Solution:',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        solution,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      // TextButton(
                      //   onPressed: () {
                      //     // Navigator.push(
                      //     //   context,
                      //     //   MaterialPageRoute(
                      //     //       builder: (context) => CoccidiosisPage()),
                      //     // );
                      //   },
                      //   child: Text(
                      //     'Read More',
                      //     style: TextStyle(color: Colors.blue),
                      //   ),
                      // ),
                    ],
                  );
  }
  //

  Widget newCastleDiseaseSymptoms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Symptoms:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        _buildSymptomItem('Respiratory distress'),
        _buildSymptomItem('Nervous signs'),
        _buildSymptomItem('Sudden death'),
        SizedBox(height: 20),
        Text(
          'Description:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Newcastle disease is a contagious viral disease that affects many bird species, including chickens. The symptoms include respiratory distress, nervous signs, and sudden death. The disease can spread rapidly through flocks, causing significant economic losses.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        Text(
          'Treatment:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        _buildTreatmentItem('Laboratory Testing'),
        _buildTreatmentItem('Veterinary Examination and Advice'),
        _buildTreatmentItem('Amprolium, enrofloxacin, and penicillin'),
        SizedBox(height: 20),
        Text(
          'Prevention:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        _buildPreventionItem('Good Hygiene Practices'),
        _buildPreventionItem('Vaccination'),
        _buildPreventionItem('Quarantine and Isolation'),
        _buildPreventionItem('Parasite control'),
        _buildPreventionItem('Separating multi-age flocks'),
      ],
    );
  }
}
