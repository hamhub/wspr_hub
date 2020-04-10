import React from 'react';
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';
// import ApolloClient from 'apollo-boost';
import { ApolloProvider } from 'react-apollo';
import { ApolloProvider as APHooks } from '@apollo/react-hooks';
import { Layout } from './components/Layout';
import { createHttpLink } from 'apollo-link-http';
import { setContext } from 'apollo-link-context';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { ApolloClient } from 'apollo-client';
const httpLink = createHttpLink({ uri: '/graphql' });

const authLink = setContext((_, { headers }) => {
  // get the authentication token from local storage if it exists
  const token = localStorage.getItem('WSPRHUB_TOKEN');

  return token
    ? {
        headers: {
          ...headers,
          authorization: token ? `Bearer ${token}` : '',
        },
      }
    : { headers };
});

export const client = new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache(),
});

export const Root: React.FC = () => (
  <ApolloProvider client={client}>
    <APHooks client={client}>
      <Router>
        <Layout />
      </Router>
    </APHooks>
  </ApolloProvider>
);
