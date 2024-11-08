# MANVSim Website

This document contains the most important information to start or continue
developing the MANVSim website.

## Prerequisites

You need to have [npm](https://npmjs.com) installed on your system. The MANVSim
server must be running and accessible from the website.

## Getting Started

While in the web directory, run the following command to install all dependencies:

```bash
npm install
```

You need to specify the URL of the MANVSim server and API. This can be done in
two ways:

Option 1: Create a `.env.local` file in the web directory and add the following
lines:

```env
VITE_SERVER_URL=*URL*
VITE_API_URL=$VITE_API_URL/*URL*

# e.g.
VITE_SERVER_URL=http://127.0.0.1:5002
VITE_API_URL=$VITE_SERVER_URL/web/
```

Option 2: Set environment variables in the terminal:

```bash
VITE_SERVER_URL=*URL* VITE_API_URL=*URL* npm run dev
```

See [here](https://vitejs.dev/guide/env-and-mode) for more information.

In practice the server URL will be `http://localhost:5002` and the API URL
`http://localhost:5002/web/` if you are running the MANVSim server locally as
shown [here](/server/README.md).

> [!NOTE]
> On MacOS you might have to use 127.0.0.1 instead of localhost.

A development instance of the website can be started with:

```bash
npm run dev
```

## Frameworks

The following frameworks are used in the website:

- [Vite](https://vitejs.dev)
- [Typescript](https://typescriptlang.org)
- [React](https://react.dev)
- [React Bootstrap](https://react-bootstrap.netlify.app)
- [React Router](https://reactrouter.com/en/main)
- [Immer](https://immerjs.github.io/immer)

## Directories

The main source code is contained in the ``./src/`` directory. The source directory is structured as follows:

| Directory        | Content                                                                     |
|------------------|-----------------------------------------------------------------------------|
| ``api/``         | Contains code that interacts with the API                                   |
| ``components/``  | React elements that can be used in multiple places                          |
| ``contexts/``    | Contains code for [React Contexts](https://react.dev/learn/passing-data-deeply-with-context) |
| ``hooks/``       | Access to the React Hooks                                                   |
| ``routes/``      | Routes that React Router uses                                               |
| ``services/``    | Miscellaneous services like authentication and access to the local storage  |

