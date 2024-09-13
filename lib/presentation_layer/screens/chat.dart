import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:bookipedia/app/api_constants.dart';
import 'package:bookipedia/app/style/app_colors.dart';
import 'package:bookipedia/cubits/file_chat/file_chat_cubit.dart';
import 'package:bookipedia/data_layer/models/books/get_books_response.dart';
import 'package:bookipedia/data_layer/models/file_chat/file_chat_request_body.dart';
import 'package:bookipedia/data_layer/models/file_chat/file_chat_response.dart';
import 'package:bookipedia/data_layer/models/question_on_file/question_on_file_response.dart';
import 'package:bookipedia/data_layer/network/dio_factory.dart';
import 'package:bookipedia/data_layer/network/error_handler.dart';
import 'package:bookipedia/main.dart';
import 'package:bookipedia/presentation_layer/widgets/alert_dialog.dart';
import 'package:bookipedia/presentation_layer/widgets/chat_buble.dart';
import 'package:bookipedia/presentation_layer/widgets/document_sources.dart';
import 'package:bookipedia/presentation_layer/widgets/loading.dart';
import 'package:bookipedia/presentation_layer/widgets/message_form_field.dart';
import 'package:bookipedia/presentation_layer/widgets/something_went_wrong.dart';
import 'package:bookipedia/presentation_layer/widgets/web_sources.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ChatView extends StatefulWidget {
  const ChatView(
      {super.key,
      required this.file,
      required this.pdfViewerController,
      required this.show,
      required this.messageController});
  final File file;
  final PdfViewerController pdfViewerController;
  final Function show;
  final TextEditingController messageController;
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late ScrollController scrollController;
  StreamSubscription<List<int>>? subscription;
  late List<Datum> messages;

  String sources = "";
  late QuestionSources src;
  List<String> _data = [];
  bool isSplitted = false;
  bool isLoadingOldMessages = false;
  bool isLoadingAnswer = false;
  bool errorHappened = false;
  bool? webRetrival = preferences.getBool("web");

  FileChatRequestBody getResquestBody() {
    return FileChatRequestBody(
        id: widget.file.id, type: widget.file is Book ? "book" : "document");
  }

  @override
  void initState() {
    FileChatCubit.get(context)
        .sendRequest(fileChatRequestBody: getResquestBody(), file: widget.file);

    scrollController = ScrollController()
      ..addListener(() {
        loadOldMessages();
      });

    super.initState();
  }

  void loadOldMessages() {
    var createdAt = messages.last.createdAt;
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        createdAt != null) {
      FileChatCubit.get(context).getMoreMessages(
          file: widget.file,
          createdAt: createdAt,
          fileChatRequestBody: getResquestBody());
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    if (subscription != null) {
      subscription!.cancel();
    }

    super.dispose();
  }

  void _fetchStreamData(question) async {
    setState(() {
      isLoadingAnswer = true;
    });
    try {
      final dio = Dio();
      log("id:${widget.file.id} file type: ${widget.file is Book ? "book" : "document"} ");
      Response response = await dio.get(
        'https://bookipedia-backend-pr-82.onrender.com/ai/question/${widget.file.id}?type=book&enable_web_retrival=${preferences.getBool("web")}',
        data: {"question": question},
        options: Options(
          responseType: ResponseType.stream,
          headers: ApiHeaders.tokenHeader,
        ),
      );
      log("done");
      subscription = response.data.stream.listen((Uint8List data) {
        setState(() {
          isLoadingAnswer = false;
        });
        log("$data");
        handleChunck(data);
      }, onDone: () {
        subscription!.cancel;
        src = QuestionSources.fromJson(json.decode(sources));
        messages.first.createdAt = "";
      }, onError: (error) {});
    } catch (e) {
      // var faliure = ErrorHandler.handle(e).failure;
      // AppAlertDialog(message: faliure.message);
    }
  }

  void handleChunck(data) {
    String chunk = utf8.decode(data);
    if (chunk.contains("[sources]")) {
      var splitted = chunk.split("[sources]");
      chunk = splitted[0];
      sources = splitted[1];
      messages.first.answer += chunk;
      setState(() {
        _data.add(chunk);
      });
      isSplitted = true;
    } else {
      if (isSplitted) {
        sources = sources + chunk;
      } else {
        messages.first.answer += chunk;
        setState(() {
          _data.add(chunk);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<FileChatCubit, FileChatState>(
          builder: (context, state) {
            messages = FileChatCubit.get(context).messages;
            return showChatBody(state);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
        ),
        child: const Icon(Icons.arrow_downward_rounded),
      ),
    );
  }

  void showSources() {
    setState(() {
      messages.first.sources = src.sources;
    });
  }

  Widget showChatBody(FileChatState state) {
    if (state is FileChatLoading) {
      return const Loading();
    } else if (State is FileChatFailure) {
      return SomethingWentWrong(
          onPressed: () => FileChatCubit.get(context).sendRequest(
              fileChatRequestBody: getResquestBody(), file: widget.file));
    } else if (State is FileChatCompleted) {
      return showMessageList(false);
    } else if (state is FileChatLoadingMoreMessages) {
      return showMessageList(true);
    }
    return showMessageList(false);
  }

  Widget showMessageList(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        isLoading
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Loading(),
              )
            : const SizedBox(),
        messages.isEmpty
            ? const Flexible(
                child: Center(
                  child: Text(
                    "How can i help you?",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              )
            : Flexible(
                fit: FlexFit.tight,
                child: ListView.separated(
                    reverse: true,
                    controller: scrollController,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    shrinkWrap: true,
                    itemCount: messages.length,
                    padding: const EdgeInsets.only(
                        left: 16, top: 16, bottom: 4, right: 18),
                    itemBuilder: (context, index) {
                      return messages[index].index == messages.length
                          ? showNewMessage(context)
                          : ChatLog(
                              messages: messages, widget: widget, index: index);
                    }),
              ),
        MessageTextField(
            messageController: widget.messageController, onPressed: sendMessage)
      ],
    );
  }

  void sendMessage() {
    FocusManager.instance.primaryFocus?.unfocus();
    String enteredText = widget.messageController.text;
    if (!(enteredText.isEmpty || enteredText == "")) {
      _data = [];
      setState(() {
        messages.insert(
            0,
            Datum(
                question: enteredText,
                answer: "",
                sources: Sources.empty(),
                index: messages.length + 1));
      });
      widget.messageController.clear();
      if (scrollController.positions.isNotEmpty) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
        );
      }

      if (mounted) {
        _fetchStreamData(enteredText);
      }
    }
  }

  Widget showNewMessage(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        errorHappened
            ? const SizedBox.shrink()
            : ChatBubble(message: messages.first.question, isQuestion: true),
        const SizedBox(
          height: 15,
        ),
        isLoadingAnswer
            ? Column(
                children: [
                  const ChatBubble(message: "", isQuestion: false),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 50,
                    child: LinearProgressIndicator(
                      color: ColorManager.primary,
                      borderRadius: const BorderRadiusDirectional.horizontal(
                          start: Radius.circular(50)),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatBubble(
                        message: _data[index],
                        isQuestion: false,
                        willBeStreamed: true,
                        showSources: showSources,
                      );
                    },
                  ),
                ],
              ),
        DocumentSources(
            pdfViewerController: widget.pdfViewerController,
            showHighlight: widget.show,
            docSources: messages.first.sources.docSources),
        WebSources(webSources: messages.first.sources.webSources)
      ],
    );
  }
}

class ChatLog extends StatelessWidget {
  const ChatLog({
    super.key,
    required this.messages,
    required this.widget,
    required this.index,
  });

  final List<Datum> messages;
  final ChatView widget;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChatBubble(message: messages[index].question, isQuestion: true),
        const SizedBox(
          height: 15,
        ),
        ChatBubble(message: messages[index].answer, isQuestion: false),
        DocumentSources(
            pdfViewerController: widget.pdfViewerController,
            showHighlight: widget.show,
            docSources: messages[index].sources.docSources),
        WebSources(webSources: messages[index].sources.webSources)
      ],
    );
  }
}
