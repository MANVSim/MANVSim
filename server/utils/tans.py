import random
import string

from flask import current_app

import models
from app_config import db

ALLOWED_CHARS = string.ascii_uppercase + string.digits


class Tan:

    def __init__(self, value: str):
        """
        Initializes a new TAN with a given string.

        Parameters:
        value (str): Value of the TAN.
        """
        self.value = value

    @classmethod
    def of_length(cls, length: int = 5) -> 'Tan':
        """
        Creates a new TAN with the given length.

        Parameters:
        length (int): The length of the TAN to generate. Default is 5.
        """
        value = "".join(random.choices(ALLOWED_CHARS, k=length))
        return cls(value)

    def __eq__(self, other):
        """
        Checks if this TAN is equal to another TAN or string, ignoring case.

        Parameters:
        other (Tan or str): The other TAN or string to compare with.

        Returns:
        bool: True if TANs or strings are equal, False otherwise.
        """
        if isinstance(other, Tan):
            return self.value.upper() == other.value.upper()
        elif isinstance(other, str):
            return self.value.upper() == other.upper()
        else:
            return False

    def __str__(self):
        """
        Returns the string representation of this TAN.

        Returns:
        str: The string representation of this TAN.
        """
        return self.value.upper()

    def __repr__(self):
        """
        Returns the developer-friendly string representation of this TAN.

        Returns:
        str: The developer-friendly string representation of this TAN.
        """
        return f"Tan({self.value.upper()!r})"

    def __hash__(self) -> int:
        return hash(self.value)


def _possible_tans(length: int) -> int:
    """ Calculates the number of possible unique TANs of the given length. """
    return len(ALLOWED_CHARS) ** length


def unique(length: int = 5) -> Tan:
    """
    Generates a unique TAN with the given length.

    Parameters:
    length (int): The length of the generated TAN. Default is 5.

    Returns:
    Tan: The generated unique TAN.

    Raises:
    ValueError: If no unique TAN of this length could be generated.
    """
    return uniques(1, length).pop()


def uniques(n: int, length: int = 5) -> list[Tan]:
    """
    Generates a list of unique TANs.

    Parameters:
    n (int): The number of unique TANs to generate.
    length (int): The length of each generated TAN. Default is 5.

    Returns:
    list[Tan]: The list of generated unique TANs.

    Raises:
    ValueError: If n is greater than the maximum possible TANs of this length.
    """
    max_tans = _possible_tans(length)
    if n > max_tans:
        raise ValueError(
            f"Cannot generate {n} unique TANs of length {length}. Maximum \
            possible TANs of this length are {max_tans}."
        )
    # Retrieve existing tans
    tans = set()
    with current_app.app_context():
        db_tans = [tan for tan, in db.session.query(models.Player.tan)]
        tans.update(db_tans)
    existing_tans = set(tans)
    # Check search space
    unique_tans_left = max_tans - len(existing_tans)
    if unique_tans_left < n:
        raise ValueError(
            f"Cannot generate {n} unique TANs due to limited permutations. \
            Unique TANs left with this length: {unique_tans_left}"
        )
    # Generate new unique tans
    while len(tans) - len(existing_tans) < n:
        tans.add(Tan.of_length(length))

    return list(tans.difference(existing_tans))
