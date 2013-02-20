#! /usr/bin/env python

import logging

from stringsync import sync


def configure_logging():
    logging.basicConfig(level=logging.INFO)


if __name__ == '__main__':
    configure_logging()
    sync.run_sync()


