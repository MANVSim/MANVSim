# Evaluation: App-Server-Communication Interface

### (REST-)API

- **Description:**
    - (RESTful) Server-API accessed by the client via HTTP(S)
- **Pros:**
    - Simple to setup and access
    - Best for CRUD-operations
    - Support in Python/Kotlin
    - Synchronization handled solely by sever
- **Cons:**
    - Not truly bidirectional, requires constant requests of state by the client (overhead)

### WebSocket/Socket.IO

- **Description:**
    - WebSocket connection between server and client via TCP
- **Pros:**
    - Truly bidirectional connection
    - Minimal communication overhead
    - Support in Python/Kotlin
- **Cons:**
    - Connection management (error handling, many parallel connections)
    - Possibly synchronization (depending on state policy)

### Message-Queues/Publish-Subscribe (Kafka, RabbitMQ, etc.)

- **Description:**
    - Event-based message queue or publish-subscribe architecture using Apache Kafka, RabbitMQ, or other implementations
- **Pros:**
    - High throughput
    - No synchronization
    - Current state always visible to everyone
- **Cons:**
    - Client possibly needs to keep track of state (even unnecessary information)
    - Higher latency than other solutions
    - Separate instance (higher complexity in software stack)

### Hybrid

- **WebSockets in front of Message/Event Queues**
- **API for reads, Events for state change**
- ...

## Overview

`+`: positive <br> `~`: neutral <br> `-`: negative

|Method      |Latency|Network Usage| Scalability |Fault Tolerance|Complexity App|Complexity Server |
|-           |-      |-            |-            |-              |-             |-                 |
|(REST-) API |`~`    |`~`          |`~`          |`~`            |`+`           |`~`               |
|WebSockets  |`+`    |`+`          |`-`          |`-`            |`~`           |`-`               |
|Event-based |`~`/`-`|`+`          |`+`          |`+`            |`-`           |`+`               |

## Conclusion

REST-API (potentially amended by WebSockets)