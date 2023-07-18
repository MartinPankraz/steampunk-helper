# SAP BTP ABAP Environment integration journey with Microsoft – Part 3

< 🏡[home](../README.md)

## Import artifacts 📥

Defined GraphQL endpoint: `https://your-own-azure-apim-domain/graphql/to/sap/odata`

- [Postman Collection with GraphQL queries](https://raw.githubusercontent.com/MartinPankraz/steampunk-helper/main/Steampunk-Helper-Lib.postman_collection.json) using [import feature](https://learning.postman.com/docs/getting-started/importing-and-exporting-data/).

- [GraphQL schema for SAP Booking OData service](./booking-schema.graphql)
- [Azure APIM Policy for OData service CSRF token and ETag handling](./booking-odata-api-policy.xml)
- [GraphQL resolver for OData Booking service GET request](./booking-odata-query-resolver.xml)
- [GraphQL resolver for OData Booking service PATCH request](./booking-odata-mutation-resolver.xml)

## Azure resources☁️

- [Import a GraphQL API | Microsoft Learn](https://learn.microsoft.com/azure/api-management/graphql-api?tabs=portal)
- [Configure a GraphQL resolver | Microsoft Learn](https://learn.microsoft.com/azure/api-management/configure-graphql-resolver)
- [Expose an Azure service via GraphQL | Microsoft Community Hub](https://techcommunity.microsoft.com/t5/azure-integration-services-blog/expose-your-data-from-azure-cosmos-db-or-azure-sql-through-a/ba-p/3846252)

## SAP Developer tutorials used 👩🏼‍🏫

- [Expose a Standard Core Data Service for ABAP Environment](https://developers.sap.com/tutorials/abap-environment-business-service-provisioning.html)
