import React from "react";
import ReactDOM from "react-dom";
import { Router, Route, IndexRoute, browserHistory } from "react-router";
import { Provider } from "react-redux";
import { syncHistoryWithStore } from "react-router-redux";
import { DrizzleProvider } from "drizzle-react";
// From UPort
import { UserIsAuthenticated } from "./util/wrappers.js";

// Layouts
import App from "./App";
import Home from "./layouts/home/Home";
import LoadingContainer from "./layouts/loading/LoadingContainer";

// Layouts from UPort
import DashboardContainer from "./layouts/dashboard/DashboardContainer";
import Profile from "./user/layouts/profile/Profile";

// Contracts
import DevAvatar from "./../build/contracts/DevAvatar.json";

// Redux Store
import store from "./store";

// Set up Material-UI
import { MuiThemeProvider, createMuiTheme } from "material-ui/styles";

// Checkout https://material.io/color/
const theme = createMuiTheme({
  palette: {
    primary: {
      light: "#534bae",
      main: "#1a237e",
      dark: "#000051",
      contrastText: "#ffffff"
    },
    secondary: {
      light: "#ffffe5",
      main: "#ffecb3",
      dark: "#cbba83",
      contrastText: "#000000"
    }
  }
});

// Initialize react-router-redux.
const history = syncHistoryWithStore(browserHistory, store);

// Set Drizzle options.
const options = {
  web3: {
    block: false,
    fallback: {
      type: "ws",
      url: "ws://127.0.0.1:7545"
    }
  },
  contracts: [DevAvatar]
};

ReactDOM.render(
  <DrizzleProvider options={options}>
    <MuiThemeProvider theme={theme}>
      <Provider store={store}>
        <LoadingContainer>
          <Router history={history}>
            <Route path="/" component={App}>
              <IndexRoute component={Home} />
              <Route
                path="dashboard"
                component={UserIsAuthenticated(DashboardContainer)}
              />
              <Route path="profile" component={UserIsAuthenticated(Profile)} />
            </Route>
          </Router>
        </LoadingContainer>
      </Provider>
    </MuiThemeProvider>
  </DrizzleProvider>,
  document.getElementById("root")
);
