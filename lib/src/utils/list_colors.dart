import 'package:flutter/material.dart';

final listColors = [
  const Color.fromRGBO(75, 135, 185, 1),
  const Color.fromRGBO(116, 180, 155, 1),
  const Color.fromRGBO(192, 108, 132, 1),
  const Color.fromRGBO(246, 114, 128, 1), 
  const Color.fromRGBO(248, 177, 149, 1), 
  const Color.fromRGBO(0, 168, 181, 1), 
  const Color.fromRGBO(255, 205, 96, 1),
  const Color.fromARGB(255, 207, 76, 76),
  const Color.fromARGB(255, 136, 84, 84),
  const Color.fromRGBO(77, 139, 185, 16),
  const Color.fromRGBO(177, 109, 135, 16),
  const Color.fromRGBO(24, 119, 125, 16),
  const Color.fromRGBO(247, 179, 145, 16),
  const Color.fromRGBO(117, 189, 155, 16),
  const Color.fromRGBO(77, 169, 185, 16),
  const Color.fromRGBO(73, 79, 165, 16),
  const Color.fromRGBO(275, 295, 95, 16),
  const Color.fromARGB(255, 207, 153, 76),
  const Color.fromARGB(255, 136, 84, 84),
  const Color.fromRGBO(75, 135, 185, 1),
  const Color.fromRGBO(152, 108, 142, 17),
  const Color.fromRGBO(256, 114, 148, 17),
  const Color.fromRGBO(258, 177, 149, 17),
  const Color.fromRGBO(156, 180, 155, 17),
  const Color.fromRGBO(5, 168, 141, 17),
  const Color.fromRGBO(73, 76, 162, 17),
  const Color.fromARGB(238, 5, 131, 131),
  const Color.fromARGB(255, 207, 153, 76),
  const Color.fromARGB(70, 104, 44, 84),
  const Color.fromRGBO(75, 135, 185, 1),
  const Color.fromRGBO(192, 108, 5, 1),
  const Color.fromRGBO(246, 80, 128, 1),
  const Color.fromRGBO(248, 177, 149, 1),
  const Color.fromRGBO(116, 180, 155, 1),
  const Color.fromRGBO(0, 168, 181, 1),
  const Color.fromRGBO(73, 76, 162, 1),
  const Color.fromRGBO(255, 205, 96, 1),
  const Color.fromARGB(255, 207, 153, 76),
  const Color.fromARGB(100, 230, 250, 84),
  const Color.fromRGBO(75, 135, 185, 1),
  const Color.fromRGBO(192, 108, 132, 1),
  const Color.fromRGBO(246, 114, 128, 1),
  const Color.fromRGBO(248, 177, 149, 1),
  const Color.fromRGBO(116, 180, 155, 1),
  const Color.fromRGBO(0, 168, 181, 1),
  const Color.fromRGBO(73, 76, 162, 1),
  const Color.fromARGB(255, 216, 130, 17),
  const Color.fromARGB(255, 132, 138, 45),
  const Color.fromARGB(145, 132, 84, 84),
  const Color.fromARGB(255, 47, 114, 45),
  const Color.fromARGB(255, 136, 46, 72),
  const Color.fromARGB(255, 236, 90, 217),
  const Color.fromARGB(255, 215, 236, 23),
  const Color.fromRGBO(116, 180, 155, 1),
  const Color.fromARGB(255, 53, 196, 206),
  const Color.fromARGB(255, 100, 73, 162),
  const Color.fromARGB(255, 255, 128, 96),
  const Color.fromARGB(255, 119, 197, 17),
  const Color.fromARGB(255, 43, 35, 119),
  const Color.fromRGBO(75, 135, 185, 1),
  const Color.fromARGB(255, 108, 192, 188),
  const Color.fromRGBO(246, 114, 128, 1),
  const Color.fromRGBO(248, 177, 149, 1),
  const Color.fromRGBO(116, 180, 155, 1),
  const Color.fromRGBO(0, 168, 181, 1),
  const Color.fromRGBO(73, 76, 162, 1),
  const Color.fromRGBO(255, 205, 96, 1),
  const Color.fromARGB(255, 207, 153, 76),
  const Color.fromARGB(255, 136, 84, 84),
  const Color.fromRGBO(75, 135, 185, 1),
  const Color.fromRGBO(192, 108, 132, 1),
  const Color.fromRGBO(246, 114, 128, 1),
  const Color.fromRGBO(248, 177, 149, 1),
  const Color.fromRGBO(116, 180, 155, 1),
  const Color.fromRGBO(0, 168, 181, 1),
  const Color.fromRGBO(73, 76, 162, 1),
  const Color.fromRGBO(255, 205, 96, 1),
  const Color.fromARGB(255, 207, 153, 76),
  const Color.fromARGB(255, 136, 84, 84),
  const Color.fromRGBO(75, 135, 185, 1),
  const Color.fromRGBO(192, 108, 132, 1),
  const Color.fromRGBO(246, 114, 128, 1),
  const Color.fromRGBO(248, 177, 149, 1),
  const Color.fromRGBO(116, 180, 155, 1),
  const Color.fromRGBO(0, 168, 181, 1),
  const Color.fromRGBO(73, 76, 162, 1),
  const Color.fromARGB(255, 181, 255, 96),
  const Color.fromARGB(255, 207, 153, 76),
  const Color.fromARGB(255, 136, 84, 84),
  const Color.fromRGBO(75, 135, 185, 1),
  const Color.fromRGBO(192, 108, 132, 1),
  const Color.fromRGBO(246, 114, 128, 1),
  const Color.fromRGBO(248, 177, 149, 1),
  const Color.fromRGBO(116, 180, 155, 1),
  const Color.fromRGBO(0, 168, 181, 1),
  const Color.fromRGBO(73, 76, 162, 1),
  const Color.fromARGB(255, 100, 184, 5),
  const Color.fromARGB(255, 207, 153, 76),
  const Color.fromARGB(255, 85, 84, 136),
  const Color.fromRGBO(75, 135, 185, 1),
  const Color.fromRGBO(192, 108, 132, 1),
  const Color.fromRGBO(246, 114, 128, 1),
  const Color.fromRGBO(248, 177, 149, 1),
  const Color.fromRGBO(116, 180, 155, 1),
  const Color.fromRGBO(0, 168, 181, 1),
  const Color.fromRGBO(73, 76, 162, 1),
  const Color.fromRGBO(255, 205, 96, 1),
  const Color.fromARGB(255, 207, 153, 76),
  const Color.fromARGB(255, 136, 84, 84),
  const Color.fromRGBO(75, 135, 185, 1),
  const Color.fromRGBO(192, 108, 132, 1),
  const Color.fromRGBO(246, 114, 128, 1),
  const Color.fromRGBO(248, 177, 149, 1),
  const Color.fromRGBO(116, 180, 155, 1),
  const Color.fromRGBO(0, 168, 181, 1),
  const Color.fromRGBO(73, 76, 162, 1),
  const Color.fromRGBO(255, 205, 96, 1),
  const Color.fromARGB(255, 207, 153, 76),
  const Color.fromARGB(255, 23, 151, 7),
  const Color.fromRGBO(75, 135, 185, 1),
  const Color.fromRGBO(192, 108, 132, 1),
  const Color.fromRGBO(246, 114, 128, 1),
  const Color.fromRGBO(248, 177, 149, 1),
  const Color.fromRGBO(116, 180, 155, 1),
  const Color.fromRGBO(0, 168, 181, 1),
  const Color.fromRGBO(73, 76, 162, 1),
  const Color.fromRGBO(255, 205, 96, 1),
  const Color.fromARGB(255, 207, 153, 76),
  const Color.fromARGB(255, 84, 136, 84),
  const Color.fromARGB(255, 16, 47, 73),
  const Color.fromARGB(255, 248, 9, 77),
  const Color.fromRGBO(246, 114, 128, 1),
  const Color.fromARGB(255, 54, 17, 2),
  const Color.fromARGB(255, 0, 226, 139),
  const Color.fromARGB(255, 145, 0, 181),
  const Color.fromRGBO(73, 76, 162, 1),
  const Color.fromRGBO(255, 205, 96, 1),
  const Color.fromARGB(255, 76, 203, 207),
  const Color.fromARGB(255, 218, 133, 23),
  const Color.fromRGBO(73, 76, 162, 1),
];
