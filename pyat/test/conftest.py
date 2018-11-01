"""
A special file that contains test fixtures for the other test files to use.
"""
import numpy
import pytest
from at import load_mat


@pytest.fixture
def rin():
    rin = numpy.array(numpy.zeros((6, 1)), order='F')
    return rin
