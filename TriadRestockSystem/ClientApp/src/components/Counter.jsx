import { useState } from "react";

const Counter = () => {
  const [counter, setCounter] = useState(0);

  return (
    <div>
      <h1>Counter</h1>

      <p>This is a simple example of a React component.</p>

      <p aria-live="polite">
        Current count: <strong>{counter}</strong>
      </p>

      <button
        className="btn btn-primary"
        onClick={() => setCounter(counter + 1)}>
        Increment
      </button>
    </div>
  );
};

export default Counter;
