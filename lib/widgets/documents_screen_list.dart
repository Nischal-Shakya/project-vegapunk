import 'package:flutter/material.dart';
import 'package:parichaya_frontend/models/conversion.dart';
import 'package:parichaya_frontend/screens/document_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/all_data.dart';

class DocumentsScreenList extends StatelessWidget {
  const DocumentsScreenList({super.key});

  @override
  Widget build(BuildContext context) {
    final List allDocumentTypes =
        Provider.of<AllData>(context, listen: false).allDocumentTypes();
    final double customWidth = MediaQuery.of(context).size.width;

    return Expanded(
        child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 5 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: allDocumentTypes.length,
      padding: EdgeInsets.symmetric(horizontal: customWidth * 0.05),
      itemBuilder: (BuildContext ctx, index) {
        return Card(
          elevation: 2,
          shadowColor: Theme.of(context).colorScheme.shadow,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, DocumentDetailScreen.routeName,
                  arguments: allDocumentTypes[index]);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      style: Theme.of(context).textTheme.labelMedium,
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
