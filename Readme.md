# Hermes

## Introduction

This is the graduate thesis work for the student Hector Miguel Rodriguez Sosa for the Computer Science 2025 class at the University of Havana.

## Project Overview

This is a data engineering project focused on a Modular Architecture for a data pipeline. The project is divided into two main parts:

1. **Research and Architecture Documentation**: All the research and architecture design documents are located in the `docs` folder. These documents are written in Typst, and you need to have [typst](https://typst.app/) installed on your system to compile them. Use `make` for compiling all the files, `make clean` for deleting the .pdf files, and `make watch <filepath>` to watch a specific file.

2. **Implementation**: The implementation of the architecture is located in the `src` directory. This implementation is a use case of the architecture, utilizing the following technologies:
    - **Java**
    - **Scala**
    - **Flink** for stream processing
    - **Kafka** for event streaming
    - **MongoDB** for data storage

The current use case is a cab share data pipeline that processes streaming data using Flink, streams events with Kafka, and stores the data in MongoDB.

## Future Work

Future enhancements to this project include:
- Adding a Monitoring Layer
- Adding a Presentation Layer
- Adding a Batch Layer using Spark