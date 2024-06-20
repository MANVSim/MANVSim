import random
import string

import models
from app import create_app
from app_config import csrf, db


ALLOWED_CHARS = string.ascii_uppercase + string.digits


class Tan:

    value: str = ""

    def __init__(self, length_or_value: int | str = 5):
        """
        Initializes a new TAN with a random value or a given string.

        Parameters:
        length_or_value (int | str): The length of the TAN to generate or a string to use as the TAN value. Default is 5.

        Raises:
        TypeError: If length_or_value is not an int or str.
        """
        if isinstance(length_or_value, int):
            self.value = "".join(random.choices(ALLOWED_CHARS, k=length_or_value))
        elif isinstance(length_or_value, str):
            self.value = length_or_value.upper()
        else:
            raise TypeError(
                f"Wrong type for Tan constructor. Expected int or str, got {type(length_or_value)}"
            )

    def __eq__(self, other):
        """
        Checks if this TAN is equal to another TAN or string, ignoring case.

        Parameters:
        other (Tan or str): The other TAN or string to compare with.

        Returns:
        bool: True if the TANs or strings are equal (ignoring case), False otherwise.
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


def possible_tans(length: int) -> int:
    """ Calculates the number of possible unique TANs of the given length. """
    return len(ALLOWED_CHARS) ** length


def uniques(n: int, length: int = 5) -> list[Tan]:
    """
    Generates a list of unique TANs.

    Parameters:
    n (int): The number of unique TANs to generate.
    length (int): The length of each generated TAN. Default is 5.

    Returns:
    list[Tan]: The list of generated unique TANs.

    Raises:
    ValueError: If n is greater than the maximum possible TANs of the given length.
    """
    if n > possible_tans(length):
        raise ValueError(
            f"Cannot generate {n} unique TANs of length {length}. Maximum possible TANs of this length are "
            f"{possible_tans(length)}."
        )
    # Retrieve existing tans
    tans = set()
    with create_app(csrf, db).app_context():
        db_tans = [tan for tan, in db.session.query(models.Player.tan).all()]
        tans.update(db_tans)
    existing_tans = set(tans)
    # Check search space
    if possible_tans(length) - len(existing_tans) < n:
        raise ValueError(
            f"Cannot generate {n} unique TANs due to limited permutations. Unique TANs left with this length: "
            f"{possible_tans(length) - len(existing_tans)}"
        )
    # Generate new unique tans
    while len(tans) - len(existing_tans) < n:
        tans.add(Tan(length))

    return list(tans.difference(existing_tans))
