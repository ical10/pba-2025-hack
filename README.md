# pba-2025-hack

#### Objective:
- Faster and easier setup for PVM backends so we can focus on building and testing smart contracts
- Initiate tooling as a base to improve DevEx on PVM development
#### Problems:
- We need to do several steps to just have a local chain running: making sure the correct dependencies are installed, cloning the Polkadot SDK repo, then building the substrate-node with the correct params to run the Kitchensink Node.
- Then we also need to run and build Eth RPC proxy: needed to translate Ethereum-compatible requests into Substrate-compatible requests.

#### Our solution:
- Create Dockerfiles to automate all of the steps above.

We need two Dockerfiles:
1. Dockerfile to build and run the kitchensink node
2. Dockerfile to build and run Eth RPC proxy

#### How to use

Build the docker image:
```
docker build -t polkadot-kitchensink .
```

Run the container:
```
docker run -p 9944:9944 -p 9933:9933 -p 30333:30333 polkadot-kitchensink
```

#### Funding avenue:
- We can ask to OpenGov or bounties to help maintain these Dockerfiles

#### References
1. https://contracts.polkadot.io/work-with-a-local-node
2. https://github.com/paritytech/rust-contract-template
3. https://github.com/paritytech/contracts-boilerplate

