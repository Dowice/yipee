import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quiz_code_page.dart'; // Import the new page

class QuizCreatorPage extends StatefulWidget {
  @override
  _QuizCreatorPageState createState() => _QuizCreatorPageState();
}

class _QuizCreatorPageState extends State<QuizCreatorPage> {
  final List<Question> _questions = [Question()];

  void _addQuestion() {
    setState(() {
      _questions.add(Question());
    });
  }

  void _removeQuestion(int index) {
    if (_questions.length > 1) {
      setState(() {
        _questions.removeAt(index);
      });
    }
  }

  String _generateQuizCode() {
    final rand = Random();
    const characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(6 + rand.nextInt(3), (index) => characters[rand.nextInt(characters.length)]).join();
  }

  void _submitQuiz() {
    final quiz = _questions.map((q) {
      return {
        'question': q.questionController.text,
        'answers': q.answerControllers.map((c) => c.text).toList(),
        'correctAnswerIndex': q.correctAnswerIndex,
      };
    }).toList();

    // Handle the submission of the quiz data
    print('Quiz: $quiz');

    // Generate a quiz code
    final quizCode = _generateQuizCode();

    // Navigate to QuizCodePage with the generated code
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizCodePage(quizCode: quizCode),
      ),
    );
  }

  @override
  void dispose() {
    for (var question in _questions) {
      question.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: Text(
          'Create Quiz',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Create Your Quiz',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Add questions and answers below. You can add multiple questions and specify which answer is correct.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 24.0),
              // Question Sections
              ...List.generate(_questions.length, (questionIndex) {
                final question = _questions[questionIndex];
                return Container(
                  margin: EdgeInsets.only(bottom: 24.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${questionIndex + 1}',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.deepPurple),
                            onPressed: () => _removeQuestion(questionIndex),
                          ),
                        ],
                      ),
                      TextField(
                        controller: question.questionController,
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Enter Question',
                          labelStyle: GoogleFonts.poppins(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: 'Type your question here...',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black38,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Answers',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      ...List.generate(question.answerControllers.length, (answerIndex) {
                        return Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: question.answerControllers[answerIndex],
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Answer ${answerIndex + 1}',
                                  labelStyle: GoogleFonts.poppins(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  hintText: 'Type your answer here...',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.black38,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.remove_circle, color: Colors.deepPurple),
                              onPressed: () => setState(() {
                                question.removeAnswerField(answerIndex);
                              }),
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () => setState(() {
                          question.addAnswerField();
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Add Answer',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Select Correct Answer',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      ...List.generate(question.answerControllers.length, (answerIndex) {
                        return RadioListTile<int>(
                          title: Text('Answer ${answerIndex + 1}'),
                          value: answerIndex,
                          groupValue: question.correctAnswerIndex,
                          onChanged: (value) {
                            setState(() {
                              question.correctAnswerIndex = value!;
                            });
                          },
                          activeColor: Colors.deepPurple,
                        );
                      }),
                    ],
                  ),
                );
              }),
              Center(
                child: ElevatedButton(
                  onPressed: _addQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Add Question',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: _submitQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Submit Quiz',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Question {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> answerControllers = [TextEditingController()];
  int correctAnswerIndex = 0;

  void addAnswerField() {
    answerControllers.add(TextEditingController());
  }

  void removeAnswerField(int index) {
    if (answerControllers.length > 1) {
      answerControllers.removeAt(index);
    }
  }

  void dispose() {
    questionController.dispose();
    for (var controller in answerControllers) {
      controller.dispose();
    }
  }
}