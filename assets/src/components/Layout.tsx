import React, { Fragment } from 'react';
import { Switch, Route } from 'react-router-dom';
import { Header } from './Header';
import { DatabasePage } from './DatabasePage';
import { HomePage } from './HomePage';
import { AboutPage } from './AboutPage';
import { DownloadsPage } from './DownloadsPage';

export const Layout: React.FC = () => (
  <Fragment>
    <Header />
    <Switch>
      <Route path="/" exact render={() => <HomePage />} />
      <Route path="/database" render={() => <DatabasePage />} />
      <Route path="/downloads" render={() => <DownloadsPage />} />
      <Route path="/about" render={() => <AboutPage />} />
    </Switch>
  </Fragment>
);
