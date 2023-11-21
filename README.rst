py3o.fusion dockerized
======================

This is a dockerized version of https://bitbucket.org/faide/py3o.fusion
py3o.fusion is a server that exposes as a web service a way to render an ODT
file into different formats.

It also provides the functionnalities of https://bitbucket.org/faide/py3o.template for the same price...


What is it?
===========

It is a server that converts native LibreOffice files to supported targets. In essence
converting ODT files to PDF at the same time as fusionning your data into the document.

Usage
=====

For a simple test or not so demanding production scenario:

.. code-block:: SH

    docker run --network host xcgd/py3o:1.0.0

Once your server is running see http://yourIP:8765 for an idea on how to use it in your own programs…

