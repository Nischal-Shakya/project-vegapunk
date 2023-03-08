import 'package:flutter/material.dart';
import 'package:parichaya_frontend/models/conversion.dart';
import 'package:parichaya_frontend/providers/preference_provider.dart';
import 'package:parichaya_frontend/screens/document_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/documents_provider.dart';

class DocumentsScreenList extends StatelessWidget {
  const DocumentsScreenList({super.key});

  @override
  Widget build(BuildContext context) {
    final List allDocumentTypes =
        Provider.of<DocumentsDataProvider>(context).getAvailableDocumentTypes();
    final double customWidth = MediaQuery.of(context).size.width;
    final darkMode = Provider.of<PreferencesProvider>(context).darkMode;

    return Expanded(
        child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 5 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: allDocumentTypes.length,
      padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
      itemBuilder: (BuildContext ctx, index) {
        return Card(
          elevation: 1,
          shadowColor: Theme.of(context).colorScheme.shadow,
          child: InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                  DocumentDetailScreen.routeName,
                  arguments: allDocumentTypes[index]);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      'assets/images/${allDocumentTypes[index]}.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      convertedFieldName(allDocumentTypes[index]),
                      style: TextStyle(
                        fontSize: 12,
                        color: darkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      softWrap: false,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ));
  }
}
