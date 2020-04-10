import React, { Fragment } from 'react';
import { Switch, Route } from 'react-router-dom';
import { Header } from './Header';
import { DatabasePage } from './DatabasePage';
import { HomePage } from './HomePage';
import { AboutPage } from './AboutPage';
import { DownloadsPage } from './DownloadsPage';
import { SignUpPage } from './SignUpPage';
import { LoginPage } from './LoginPage';
export const Layout: React.FC = () => (
  <Fragment>
    <Header />
    <Switch>
      <Route path="/" exact render={() => <HomePage />} />
      <Route path="/database" render={() => <DatabasePage />} />
      <Route path="/downloads" render={() => <DownloadsPage />} />
      <Route path="/about" render={() => <AboutPage />} />
      <Route path="/sign_up" render={() => <SignUpPage />} />
      <Route
        path="/login"
        render={({ history }) => <LoginPage history={history} />}
      />
    </Switch>
  </Fragment>
);
