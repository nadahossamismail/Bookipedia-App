<h1 align="center">
  <img src="https://github.com/user-attachments/assets/56e1ebac-3864-4771-82fd-ff42171623e8" alt="Logo" width="25" height="25" >
  Bookipedia
  </h1> 


<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white" alt="Git">
  <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub">
  <img src="https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white" alt="Postman">
    <img src="https://img.shields.io/badge/Visual_Studio_Code-0078D4?style=for-the-badge&logo=visual-studio-code&logoColor=white" alt="Visual Studio Code">

</p>
<p align="center"> Welcome to Bookipedia, a mobile app designed to enhance readers' understanding of various topics using AI-based features. This repository contains the source code for the Bookipedia app, developed as a graduation project.</p>

## Table of contents

- [Features](#features) 
- [Demo](#demo)
- [Screenshots](#screenshots)
- [Dependencies](#dependencies)
- [Installation](#installation)



## Features  
- **PDF Viewer:** Integrated using the Syncfusion PDF Viewer package to provide a seamless reading experience.
- **Upload document:** Easily add your own PDF files within the app.
- **Library:** Access a collection of books to read directly within the app.
- **Chat:** Interact with AI to ask questions and receive insights based on your reading material.
- **Summarization:** Condense lengthy documents into brief summaries highlighting essential information.
- **Text to speech:** Convert written text into speech for hands-free listening on the go.

## Demo
To see Bookipedia in action, check out the following [demo](https://youtu.be/nAMgcgXR6ZE).


## Screenshots 
 <img src="https://github.com/user-attachments/assets/fb7590db-59f9-4c4f-bf68-c93ae2e13448" alt="Home" width="200" height="450" >
  <img src="https://github.com/user-attachments/assets/a1fbce3b-f3d5-467f-a752-8da7b2760e46" alt="Home" width="200" height="450" >
   <img src="https://github.com/user-attachments/assets/b3388063-9d3e-4584-ba09-bb2d8d206928" alt="Library" width="200" height="450" >
    <img src="https://github.com/user-attachments/assets/329e064e-1100-40bc-91af-1db4947a4685" alt="Bookshelf" width="200" height="450" >
 <img src="https://github.com/user-attachments/assets/600369d8-d5b6-4a58-8731-b2229aced30b" alt="Documents" width="200" height="450" >
 <img src="https://github.com/user-attachments/assets/2d285081-4d8f-496d-b98e-270ef9a5fbf8" alt="PdfViewer" width="200" height="450" >
 <img src="https://github.com/user-attachments/assets/d784f110-6e1b-43ed-918e-2eae4c71e1e5" alt="Chat" width="200" height="450" >
 <img src="https://github.com/user-attachments/assets/f88edf0e-37ff-46c0-a8a7-3f1b5486d52a" alt="text to speech" width="200" height="450" >

## Dependencies

Bookipedia relies on several key dependencies to provide its functionality:
-  [**dio:**](https://pub.dev/packages/dio) A powerful HTTP client for Dart, supporting advanced features like interceptors, global configuration, and file uploading.
-  [**pretty_dio_logger:**](https://pub.dev/packages/pretty_dio_logger)  A Dio plugin that provides formatted and colored logs for easy debugging of network requests.
-  [**flutter_bloc:**](https://pub.dev/packages/flutter_bloc) A state management library that helps implement the BLoC (Business Logic Component) pattern, making it easy to separate presentation and logic in Flutter apps.
-  [**bloc:**](https://pub.dev/packages/bloc) The core package for the BLoC pattern, providing tools to manage states and events in a reactive way.
-  [**syncfusion_flutter_pdfviewer:**](https://pub.dev/packages/syncfusion_flutter_pdfviewer)  A versatile PDF viewer for Flutter, enabling smooth rendering and interaction with PDF documents.
-  [**file_picker:**](https://pub.dev/packages/file_picker)  A plugin that allows users to pick files from the device's file system, supporting various file types and platforms.
-  [**audioplayers:**](https://pub.dev/packages/audioplayers) A cross-platform audio player plugin for Flutter, allowing you to play audio files, streams, and assets.
 
## Installation
To get started with Bookipedia, follow these steps:

1. **Clone the repository:**
    ```bash
    git clone https://github.com/nadahossamismail/Bookipedia.git
    cd Bookipedia
    ```
    
2. **Install dependencies:**
    ```bash
    flutter pub get
    ```

3. **Run the app:**
    ```bash
    flutter run
    ```

