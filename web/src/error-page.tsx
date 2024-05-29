import { isRouteErrorResponse, useRouteError } from "react-router-dom";

export default function ErrorPage() {
  const error = useRouteError();
  console.error(error);
  let errorDisplayed: string = "Unkown error"
  if (isRouteErrorResponse(error)) {
    errorDisplayed = `${error.status} ${error.statusText}`
  } else if (error instanceof Error) {
    errorDisplayed = error.message
  } else if (typeof error === 'string') {
    errorDisplayed = error
  }

  return (
    <div id="error-page">
      <h1>Oops!</h1>
      <p>Sorry, an unexpected error has occurred.</p>
      <p>
        <i>{errorDisplayed}</i>
      </p>
    </div>
  );
}
