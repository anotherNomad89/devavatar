import React, { Component } from "react";
import { ContractData, ContractForm } from "drizzle-react-components";
import Poller from "../../util/Poller";

class Dashboard extends Component {
  constructor(props, { authData }) {
    super(props);
    authData = this.props;
    // console.log(this.props.contracts.DevAvatar);
  }

  render() {
    return (
      <main className="container">
        <div className="pure-g">
          <div className="pure-u-1-1">
            <h1>Dashboard</h1>
            <p>
              <strong>Welcome, {this.props.authData.name}</strong>
              {/* Click below to mint your own ERC998 DevAvatar token with your name
              on it! */}
            </p>
            <Poller
              contract="DevAvatar"
              method="balanceOf"
              methodArgs={[this.props.accounts[0]]}
              tname={this.props.authData.name}
            />
            <br />
            <ContractData
              contract="DevAvatar"
              method="tokenOfOwnerByIndex"
              methodArgs={[
                this.props.accounts[0],
                0,
                { from: this.props.accounts[0] }
              ]}
            />
            {/* <h2>SimpleStorage</h2> */}
            {/* <p>
              This shows a simple ContractData component with no arguments,
              along with a form to set its value.
            </p> */}
            {/* <p>
              <strong>Stored Value</strong>:{" "}
              <ContractData contract="SimpleStorage" method="storedData" />
            </p>
            <ContractForm contract="SimpleStorage" method="set" /> */}

            {/* <br />
            <br /> */}
          </div>

          {/* <div className="pure-u-1-1">
            <h2>DevAvatar</h2>
            <p>
              Here we have a form with custom, friendly labels. Also note the
              token symbol will not display a loading indicator. We've
              suppressed it with the <code>hideIndicator</code> prop because we
              know this variable is constant.
            </p>
            <p>
              <strong>Total Supply</strong>:{" "}
              <ContractData
                contract="TutorialToken"
                method="totalSupply"
                methodArgs={[{ from: this.props.accounts[0] }]}
              />{" "}
              <ContractData
                contract="TutorialToken"
                method="symbol"
                hideIndicator
              />
            </p>
            <p>
              <strong>My Balance</strong>:{" "}
              <ContractData
                contract="TutorialToken"
                method="balanceOf"
                methodArgs={[this.props.accounts[0]]}
              />
            </p>
            <h3>Send Tokens</h3>
            <ContractForm
              contract="TutorialToken"
              method="transfer"
              labels={["To Address", "Amount to Send"]}
            />

            <br />
            <br />
          </div> */}

          {/* <div className="pure-u-1-1">
            <h2>ComplexStorage</h2>
            <p>
              Finally this contract shows data types with additional
              considerations. Note in the code the strings below are converted
              from bytes to UTF-8 strings and the device data struct is iterated
              as a list.
            </p>
            <p>
              <strong>String 1</strong>:{" "}
              <ContractData contract="ComplexStorage" method="string1" toUtf8 />
            </p>
            <p>
              <strong>String 2</strong>:{" "}
              <ContractData contract="ComplexStorage" method="string2" toUtf8 />
            </p>
            <strong>Single Device Data</strong>:{" "}
            <ContractData contract="ComplexStorage" method="singleDD" />
            <br />
            <br />
          </div> */}
        </div>
      </main>
    );
  }
}

export default Dashboard;
