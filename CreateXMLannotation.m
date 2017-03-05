function CreateXMLannotation(ObjectArray)

% Create  Root Node
docNode = com.mathworks.xml.XMLUtils.createDocument('annotation');
docRootNode = docNode.getDocumentElement;

% Folder Node Creation
folderNode = docNode.createElement('folder');
folderNode.appendChild(docNode.createTextNode(['\CVSI2017','\',ObjectArray.ObjectName]));
docRootNode.appendChild(folderNode);

% FileName Node Creation
fileNameNode= docNode.createElement('filename');
fileNameNode.appendChild(docNode.createTextNode(ObjectArray.FileName));
docRootNode.appendChild(fileNameNode);

% Create Source Node
sourceElement= docNode.createElement('source');
docRootNode.appendChild(sourceElement);

% Create Child elements to Source Node
% 1. Database element
databaseElement= docNode.createElement('database');
databaseElement.appendChild(docNode.createTextNode('CVSI2017'));
sourceElement.appendChild(databaseElement);

% 2. Annotation
annotationElement= docNode.createElement('annotation');
annotationElement.appendChild(docNode.createTextNode('Pascal Voc Type'));
sourceElement.appendChild(annotationElement);

% Create Size Node
sizeElement= docNode.createElement('size');
docRootNode.appendChild(sizeElement);

% Create the Child elements to Size Node
% 1. width
widthElement= docNode.createElement('width');
widthElement.appendChild(docNode.createTextNode(num2str(ObjectArray.ImgWD)));
sizeElement.appendChild(widthElement);

% 2. height
heightElement= docNode.createElement('height');
heightElement.appendChild(docNode.createTextNode(num2str(ObjectArray.ImgHT)));
sizeElement.appendChild(heightElement);

% 3. depth
depthElement= docNode.createElement('depth');
depthElement.appendChild(docNode.createTextNode(num2str(ObjectArray.ImgDept)));
sizeElement.appendChild(depthElement);

% Segemented Node Creation
segmentedNode = docNode.createElement('script');
segmentedNode.appendChild(docNode.createTextNode(ObjectArray.ObjectName));
docRootNode.appendChild(segmentedNode);

fnameSplit = strsplit(ObjectArray.FileName, '.');
xmlFileName = [ObjectArray.XMLFolder,'\annotation\',fnameSplit{1},'.xml'];
xmlwrite(xmlFileName,docNode);
%edit(xmlFileName);

end