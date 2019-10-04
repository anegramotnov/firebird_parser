# WIP: Firebird SQL Parser

[![Build Status](https://travis-ci.org/anegramotnov/firebird_parser.svg?branch=master)](https://travis-ci.org/anegramotnov/firebird_parser)
[![codecov](https://codecov.io/gh/anegramotnov/firebird_parser/branch/master/graph/badge.svg)](https://codecov.io/gh/anegramotnov/firebird_parser)


Парсер диалекта SQL, используемого в Firebird. Заготовка для статического анализатора Firebird SQL.

В данный момент реализован самописный лексер, корректно распознающий лексемы Firebird.

# Использование

* Установка зависимостей
  ```
  pip install -r requirements.txt
  ```
* Запуск лексера
  ```
  python tokenizer.py <sql_file_path>
  ```
* Запуск тестов
  ```
  python -m pytest tests/test_tokenizer.py
  ```

