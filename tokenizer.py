from typing import NamedTuple, List, Tuple, Iterator, Optional, Pattern, Callable
import re


class UnexpectedLexeme(BaseException):
    def __init__(self, msg: str):
        super().__init__()
        self.msg = msg

    def __str__(self):
        return f'{self.__class__.__name__}: {self.msg}'


class LexerRule(NamedTuple):
    token_name: str
    regex: Pattern
    callback: Optional[Callable] = None


class LexerState(NamedTuple):
    max_position: int
    position: int
    line: int
    column: int


# @dataclass
class Token(NamedTuple):
    start_line: int
    start_column: int
    end_line: int
    end_column: int
    name: str
    value: str

    # according to following issue: https://github.com/PyCQA/pylint/issues/2688
    # pylint: disable=no-member
    def __repr__(self):
        return '{sl},{sc}\t{el},{ec}\t{name}\t{value}'.format(
            sl=self.start_line,
            sc=self.start_column,
            el=self.end_line,
            ec=self.end_column,
            name=self.name.ljust(8),
            value=repr(self.value),
        )
    # pylint: enable=no-member


def get_new_lexer_state(lexer_state: LexerState, token_value: str) -> LexerState:
    token_length = len(token_value)

    newline_count = token_value.count('\n')

    new_line = lexer_state.line + newline_count

    if newline_count > 0:
        last_newline_position = token_value.rindex('\n')
        new_column = token_length - (last_newline_position + 1)
    else:
        new_column = lexer_state.column + token_length

    new_position = lexer_state.position + token_length

    new_lexer_state = lexer_state._replace(
        position=new_position,
        line=new_line,
        column=new_column,
    )

    return new_lexer_state


# from https://firebirdsql.org/refdocs/langrefupd25-reskeywords-full-reswords.html
RESERVERD_WORDS = {
    'ADD', 'ADMIN', 'ALL', 'ALTER', 'AND', 'ANY', 'AS', 'AT', 'AVG', 'BEGIN', 'BETWEEN', 'BIGINT',
    'BIT_LENGTH', 'BLOB', 'BOTH', 'BY', 'CASE', 'CAST', 'CHAR', 'CHAR_LENGTH', 'CHARACTER', 'CHARACTER_LENGTH',
    'CHECK', 'CLOSE', 'COLLATE', 'COLUMN', 'COMMIT', 'CONNECT', 'CONSTRAINT', 'COUNT', 'CREATE', 'CROSS', 'CURRENT',
    'CURRENT_CONNECTION', 'CURRENT_DATE', 'CURRENT_ROLE', 'CURRENT_TIME', 'CURRENT_TIMESTAMP', 'CURRENT_TRANSACTION',
    'CURRENT_USER', 'CURSOR', 'DATE', 'DAY', 'DEC', 'DECIMAL', 'DECLARE', 'DEFAULT', 'DELETE', 'DISCONNECT',
    'DISTINCT', 'DOUBLE', 'DROP', 'ELSE', 'END', 'ESCAPE', 'EXECUTE', 'EXISTS', 'EXTERNAL', 'EXTRACT', 'FETCH',
    'FILTER', 'FLOAT', 'FOR', 'FOREIGN', 'FROM', 'FULL', 'FUNCTION', 'GDSCODE', 'GLOBAL', 'GRANT', 'GROUP',
    'HAVING', 'HOUR', 'IN', 'INDEX', 'INNER', 'INSENSITIVE', 'INSERT', 'INT', 'INTEGER', 'INTO', 'IS', 'JOIN',
    'LEADING', 'LEFT', 'LIKE', 'LONG', 'LOWER', 'MAX', 'MAXIMUM_SEGMENT', 'MERGE', 'MIN', 'MINUTE', 'MONTH',
    'NATIONAL', 'NATURAL', 'NCHAR', 'NO', 'NOT', 'NULL', 'NUMERIC', 'OCTET_LENGTH', 'OF', 'ON', 'ONLY', 'OPEN',
    'OR', 'ORDER', 'OUTER', 'PARAMETER', 'PLAN', 'POSITION', 'POST_EVENT', 'PRECISION', 'PRIMARY', 'PROCEDURE',
    'RDB$DB_KEY', 'REAL', 'RECORD_VERSION', 'RECREATE', 'RECURSIVE', 'REFERENCES', 'RELEASE', 'RETURNING_VALUES',
    'RETURNS', 'REVOKE', 'RIGHT', 'ROLLBACK', 'ROW_COUNT', 'ROWS', 'SAVEPOINT', 'SECOND', 'SELECT', 'SENSITIVE',
    'SET', 'SIMILAR', 'SMALLINT', 'SOME', 'SQLCODE', 'SQLSTATE', 'START', 'SUM', 'TABLE', 'THEN', 'TIME',
    'TIMESTAMP', 'TO', 'TRAILING', 'TRIGGER', 'TRIM', 'UNION', 'UNIQUE', 'UPDATE', 'UPPER', 'USER', 'USING',
    'VALUE', 'VALUES', 'VARCHAR', 'VARIABLE', 'VARYING', 'VIEW', 'WHEN', 'WHERE', 'WHILE', 'WITH', 'YEAR'
}

# from https://firebirdsql.org/refdocs/langrefupd25-reskeywords-full-keywords.html
KEYWORDS = {
    'ABS', 'ACCENT', 'ACOS', 'ACTION', 'ACTIVE', 'AFTER', 'ALWAYS', 'ASC', 'ASCENDING', 'ASCII_CHAR', 'ASCII_VAL',
    'ASIN', 'ATAN', 'ATAN2', 'AUTO', 'AUTONOMOUS', 'BACKUP', 'BEFORE', 'BIN_AND', 'BIN_NOT', 'BIN_OR', 'BIN_SHL',
    'BIN_SHR', 'BIN_XOR', 'BLOCK', 'BREAK', 'CALLER', 'CASCADE', 'CEIL', 'CEILING', 'CHAR_TO_UUID', 'COALESCE',
    'COLLATION', 'COMMENT', 'COMMITTED', 'COMMON', 'COMPUTED', 'CONDITIONAL', 'CONTAINING', 'COS', 'COSH', 'COT',
    'CSTRING', 'DATA', 'DATABASE', 'DATEADD', 'DATEDIFF', 'DECODE', 'DELETING', 'DESC', 'DESCENDING', 'DESCRIPTOR',
    'DIFFERENCE', 'DO', 'DOMAIN', 'ENTRY_POINT', 'EXCEPTION', 'EXIT', 'EXP', 'FILE', 'FIRST', 'FIRSTNAME', 'FLOOR',
    'FREE_IT', 'GEN_ID', 'GEN_UUID', 'GENERATED', 'GENERATOR', 'GRANTED', 'HASH', 'IF', 'IGNORE', 'IIF', 'INACTIVE',
    'INPUT_TYPE', 'INSERTING', 'ISOLATION', 'KEY', 'LAST', 'LASTNAME', 'LEAVE', 'LENGTH', 'LEVEL', 'LIMBO', 'LIST',
    'LN', 'LOCK', 'LOG', 'LOG10', 'LPAD', 'MANUAL', 'MAPPING', 'MATCHED', 'MATCHING', 'MAXVALUE', 'MIDDLENAME',
    'MILLISECOND', 'MINVALUE', 'MOD', 'MODULE_NAME', 'NAMES', 'NEXT', 'NULLIF', 'NULLS', 'OPTION', 'OS_NAME',
    'OUTPUT_TYPE', 'OVERFLOW', 'OVERLAY', 'PAD', 'PAGE', 'PAGE_SIZE', 'PAGES', 'PASSWORD', 'PI', 'PLACING', 'POWER',
    'PRESERVE', 'PRIVILEGES', 'PROTECTED', 'RAND', 'READ', 'REPLACE', 'REQUESTS', 'RESERV', 'RESERVING', 'RESTART',
    'RESTRICT', 'RETAIN', 'RETURNING', 'REVERSE', 'ROLE', 'ROUND', 'RPAD', 'SCALAR_ARRAY', 'SCHEMA', 'SEGMENT',
    'SEQUENCE', 'SHADOW', 'SHARED', 'SIGN', 'SIN', 'SINGULAR', 'SINH', 'SIZE', 'SKIP', 'SNAPSHOT', 'SORT', 'SOURCE',
    'SPACE', 'SQRT', 'STABILITY', 'STARTING', 'STARTS', 'STATEMENT', 'STATISTICS', 'SUB_TYPE', 'SUBSTRING', 'SUSPEND',
    'TAN', 'TANH', 'TEMPORARY', 'TIMEOUT', 'TRANSACTION', 'TRUNC', 'TWO_PHASE', 'TYPE', 'UNCOMMITTED', 'UNDO',
    'UPDATING', 'UUID_TO_CHAR', 'WAIT', 'WEEK', 'WEEKDAY', 'WORK', 'WRITE', 'YEARDAY'
}


# pylint: disable=bad-whitespace
OPERATORS = [
    ('ASTERISK',    r'\*'),
    ('COMMA',       r','),
    ('EQUAL',       r'='),
    ('SEMI',        r';'),
    ('COLON',       r':'),
    ('DIVIDE',      r'/'),
    ('LPAR',        r'\('),
    ('RPAR',        r'\)'),
    ('DOT',         r'\.'),
    ('PLUS',        r'\+'),
    ('MINUS',       r'-'),
    ('NE',          r'<>'),
    ('NE',          r'!='),
    ('LE',          r'<='),
    ('GT',          r'>'),
    ('LT',          r'<'),
    ('OR',          r'\|\|'),  # TODO: catenate operator!
]
# pylint: enable=bad-whitespace


IDX = r'[a-z_][\w\$]*'  # TODO: specify identifier regexp
SPACE = r'[ \t]+'
NEWLINE = r'\n'
MLCOMMENT = r'/\*(.|\n)*?\*/'
SLCOMMENT = r'--[^\n]*\n'

STRING = r"('|\")(.|\n)*?('|\")"  # TODO: escape sequence


FLOAT_LITERAL = r'\d+\.\d+'
INTEGER_LITERAL = r'\d+'


def id_callback(token: Token) -> Token:
    if token.value.upper() in RESERVERD_WORDS:
        token = token._replace(name='RESERVED')
    elif token.value.upper() in KEYWORDS:  # pylint: disable=undefined-loop-variable
        token = token._replace(name='KEYWORD')
    return token


LEXER_RULES = \
    [LexerRule('SLCOMMENT', re.compile(SLCOMMENT))] + \
    [LexerRule('MLCOMMENT', re.compile(MLCOMMENT))] + \
    [LexerRule(op, re.compile(regex)) for op, regex in OPERATORS] + \
    [LexerRule('ID', re.compile(IDX, re.IGNORECASE), id_callback)] + \
    [LexerRule('FLOAT', re.compile(FLOAT_LITERAL))] + \
    [LexerRule('INT', re.compile(INTEGER_LITERAL))] + \
    [LexerRule('STRING', re.compile(STRING))] + \
    [LexerRule('SPACE', re.compile(SPACE))] + \
    [LexerRule('NEWLINE', re.compile(NEWLINE))]


def get_next_token(state: LexerState, source: str, rules: List[LexerRule]) -> Tuple[LexerState, Optional[Token]]:
    for name, regex, callback in rules:
        # pylint: disable=invalid-name
        m = regex.match(source)
        if m:
            token_value = m.group()
            # pylint: enable=invalid-name
            # TODO: move to tokenize?
            new_state = get_new_lexer_state(state, token_value)
            token = Token(
                start_line=state.line,
                start_column=state.column,
                end_line=new_state.line,
                end_column=new_state.column,
                name=name,
                value=token_value,
            )
            if callback:
                token = callback(token)
            return new_state, token

    exc_buffer = source[:80]
    raise UnexpectedLexeme(f"{state.line}:{state.column}: '{exc_buffer}'")


def tokenize(source: str) -> Iterator[Token]:
    state = LexerState(
        max_position=len(source),
        position=0,
        line=1,
        column=0,
    )

    while state.position < state.max_position:

        source_tail = source[state.position:]
        try:
            state, next_token = get_next_token(state, source_tail, LEXER_RULES)
        except UnexpectedLexeme as ex:
            print(ex)
            break
        if next_token:
            yield next_token


if __name__ == '__main__':
    import sys
    from pathlib import Path

    with Path(sys.argv[1]).absolute().open(encoding='utf-8') as f:
        for token in tokenize(f.read()):
            print(token)
