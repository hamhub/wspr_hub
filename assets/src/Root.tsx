import React from 'react';
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';
import ApolloClient from 'apollo-boost';
import { ApolloProvider } from 'react-apollo';
import { Layout } from './components/Layout';

const client = new ApolloClient({
  uri: '/graphql',
});

export const Root: React.FC = () => (
  <ApolloProvider client={client}>
    <Router>
      <Layout />
    </Router>
  </ApolloProvider>
);
