## Basic description
Using Azure as cloud provider.

Will use taxicab kaggle dataset found in data/ folder as the input data to show my knowledge.
- Will use pub/sub pattern for the streaming events
- Therefore we should use Azure Service bus for message delivery.

Perhaps we need to use IOT hub to pretend to be an IOT device generating the events and submitting them to the service bus?
- Maybe, even if it isnt needed, we could implement this for learning purposes.

Will use stream analytics (microsoft Fabric) to process the events

We will ensure the data only ever flows through a private network, for practice with security.

We will need to implement a CI/CD process, and infrastructure as code.

Wide coverage of tools and technologies is most important.

Peex has problems with AI genereated code - people dont understand whats happening

Use bicep instead of terraform for resourcing

## People Excellence (PeEx) jobs to cover

### Streaming 
01. Use advanced capabilities of message broker systems
Perform tuning (latency and throughput) and scaling of the message broker system.

02. Use advanced operations of streaming processing
Perform streaming framework performance tuning (latency and throughput) and scaling.

03. Design and implement scalable streaming applications
Develop a streaming application by using APIs or SDKs in a manner where you will be able to tune throughput and latency. Show how autoscaling of shards or topics works and how it influences the performance of the application.

### Data Ops
01.  Integrate data services with private networks
Provide a virtual network that enables cloud resources to securely communicate with each other, the Internet, and on-premises networks.

02. Lead the continuous integration tools selection, configuration, adoption, and decommissioning
Follow CI/CD best practices. Script multiphase build process. Integrate building of a product installer. Generate release notes and other release documentation. Develop scheduled builds. Monitor the build process.

03.  Lead the setup process of software construction model
Demonstrate listed knowledge and practical experience:
Apply the concepts of software processes and software process models.
Know software process models and when they can be used.
Know about the fundamental process activities of software requirements engineering, software development, testing, and evolution.
Understand why processes should be organized to cope with changes in the software requirements and design.
Understand the notion of software process improvement and the factors that affect software process quality.

