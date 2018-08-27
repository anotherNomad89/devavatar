import { Connect, SimpleSigner } from "uport-connect";

export let uport = new Connect("DevAvatar", {
  clientId: "2oqBCTb4gtvDeB1J7m9DkNx6XCYnkpmvSyL",
  network: "rinkeby",
  signer: SimpleSigner(
    "2b6a8629bc8408d123693cb7e843c1b4184b0e68e848ca63980fc69d8ea7b5f7"
  )
});
export const web3 = uport.getWeb3();
