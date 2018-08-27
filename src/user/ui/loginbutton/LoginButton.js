import React from "react";
import Button from "material-ui/Button";

// Images
import uPortLogo from "../../../img/uport-logo.svg";

const LoginButton = ({ onLoginUserClick }) => {
  return (
    <Button
      color="secondary"
      style={{ fontFamily: "Arial" }}
      onClick={event => onLoginUserClick(event)}
    >
      <img className="uport-logo" src={uPortLogo} alt="UPort Logo" />
      Login with UPort
    </Button>
  );
};

export default LoginButton;

/*
<a href="#" onClick={(event) => onLoginUserClick(event)}>
  Login with UPort
</a>
*/
