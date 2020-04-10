import React, { useState } from 'react';
import { Link, withRouter } from 'react-router-dom';
import gql from 'graphql-tag';
import { useQuery } from '@apollo/react-hooks';
import { client } from '../Root';

const CURRENT_USER = gql`
  query {
    currentUser {
      email
      displayName
      callsign
      location
    }
  }
`;

export const Header: React.FC = withRouter(({ history }) => {
  const { data, error, loading } = useQuery(CURRENT_USER);
  const [isProfileOpen, setProfileOpen] = useState(false);

  const handleLogout = () => {
    setProfileOpen(false);
    localStorage.removeItem('WSPRHUB_TOKEN');
    client.resetStore();
    history.push('/');
  };
  return (
    <nav className="navbar" role="navigation" aria-label="main navigation">
      <div className="navbar-brand">
        <a className="navbar-item" href="/">
          WSPR Hub
        </a>

        <a
          role="button"
          className="navbar-burger burger"
          aria-label="menu"
          aria-expanded="false"
          data-target="navbarBasicExample"
        >
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
        </a>
      </div>

      <div id="navbarBasicExample" className="navbar-menu">
        <div className="navbar-start">
          <Link to="/" className="navbar-item">
            Home
          </Link>

          <Link to="/database" className="navbar-item">
            Database
          </Link>

          <Link to="/downloads" className="navbar-item">
            Downloads
          </Link>

          <Link to="/about" className="navbar-item">
            About
          </Link>
        </div>

        <div className="navbar-end is-flex-mobile is-flex-tablet">
          <div className="navbar-item">
            {loading ? (
              <div />
            ) : data.currentUser ? (
              <div className={`dropdown ${isProfileOpen ? 'is-active' : ''}`}>
                <div className="dropdown-trigger">
                  <button
                    className="button is-white"
                    aria-haspopup="true"
                    aria-controls="dropdown-menu"
                    onClick={() => setProfileOpen(!isProfileOpen)}
                  >
                    <span>{data.currentUser.displayName}</span>
                    <span className="icon is-small">
                      <i className="fa fa-angle-down" aria-hidden="true"></i>
                    </span>
                  </button>
                </div>
                <div className="dropdown-menu" role="menu">
                  <div className="dropdown-content">
                    <a href="#" className="dropdown-item">
                      Account Settings
                    </a>

                    <hr className="dropdown-divider" />

                    <button
                      className="button is-white dropdown-item"
                      type="button"
                      onClick={handleLogout}
                    >
                      Logout
                    </button>
                  </div>
                </div>
              </div>
            ) : (
              <div className="buttons">
                <Link to="/sign_up" className="button is-primary">
                  <strong>Sign up</strong>
                </Link>
                <Link to="/login" className="button is-light">
                  Log in
                </Link>
              </div>
            )}
          </div>
        </div>
      </div>
    </nav>
  );
});
