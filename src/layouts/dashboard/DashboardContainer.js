import Dashboard from "./Dashboard";
import { drizzleConnect } from "drizzle-react";

// May still need this even with data function to refresh component on updates for this contract.
const mapStateToProps = state => {
  return {
    accounts: state.accounts,
    SimpleStorage: state.contracts.SimpleStorage,
    DevAvatar: state.contracts.DevAvatar,
    drizzleStatus: state.drizzleStatus,
    contracts: state.contracts
  };
};

const DashboardContainer = drizzleConnect(Dashboard, mapStateToProps);

export default DashboardContainer;
