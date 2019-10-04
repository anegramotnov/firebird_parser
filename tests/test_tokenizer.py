from pathlib import Path
from typing import List, Iterator, Tuple

import pytest

from tokenizer import tokenize

TEST_DIRECTORY = Path(__file__)

SOURCES_DIRECTORY = TEST_DIRECTORY.parent.joinpath("sources")
TOKENIZER_DIRECTORY = TEST_DIRECTORY.parent.joinpath("tokens")


def get_all_sql_files() -> List[Path]:
    sources = Path(__file__).parent.joinpath("cases").glob("*.sql")
    return sources


def get_token_files() -> Iterator[Path]:
    token_files = TOKENIZER_DIRECTORY.iterdir()
    for token_file in token_files:
        if not token_file.name.startswith("skip"):
            yield token_file


def get_file_content(file: Path) -> str:
    with file.open(encoding="utf-8") as stream:
        return stream.read()


def get_source_by_name(source_name: str) -> str:
    source_file = SOURCES_DIRECTORY.joinpath(f"{source_name}.sql")
    return get_file_content(source_file)


def get_case_pairs() -> List[Tuple[str, Iterator[str]]]:
    token_files = get_token_files()
    pairs = []
    for token_file in token_files:
        source_name = token_file.name.split(".")[0]
        source = get_source_by_name(source_name=source_name)
        etalon_token_dump = get_file_content(file=token_file)
        etalon_tokens = iter(etalon_token_dump.strip().split("\n"))
        pairs.append((source, etalon_tokens))
    return pairs


@pytest.mark.parametrize("source, etalon_tokens", get_case_pairs())
def test_tokenize(source: str, etalon_tokens: str):
    tokens = tokenize(source)

    assert len(list(tokens)) == len(list(etalon_tokens))

    token_pairs = zip(tokens, etalon_tokens)
    for token, etalon_token in token_pairs:
        assert str(token) == etalon_token
