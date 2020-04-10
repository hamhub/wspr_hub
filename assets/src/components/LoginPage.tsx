import React from 'react';
import { Formik, FormikValues, FormikActions } from 'formik';
import * as Yup from 'yup';
import { TextField } from './common/TextField';
import { Link } from 'react-router-dom';
import { useMutation } from '@apollo/react-hooks';
import gql from 'graphql-tag';

import { client } from '../Root';

const AUTHENTICATE_ACCOUNT = gql`
  mutation($email: String!, $password: String!) {
    authenticateUser(email: $email, password: $password) {
      token
    }
  }
`;

interface AuthenticationFormValues {
  email: string;
  password: string;
}

interface AuthenticateUser {
  token: string;
}

interface AuthenticationData {
  authenticateUser: AuthenticateUser;
}

export const LoginPage = ({ history }) => {
  const [authenticateUser] = useMutation<
    AuthenticationData,
    AuthenticationFormValues
  >(AUTHENTICATE_ACCOUNT);

  const handleSubmit = (
    values: AuthenticationFormValues,
    actions: FormikActions<AuthenticationFormValues>,
  ) => {
    return authenticateUser({
      variables: {
        email: values.email,
        password: values.password,
      },
    }).then(
      ({ data }) => {
        if (data.authenticateUser.token) {
          localStorage.setItem('WSPRHUB_TOKEN', data.authenticateUser.token);
          client.resetStore();
          history.push('/');
        }
        actions.setSubmitting(false);
      },
      _result => {
        actions.setSubmitting(false);
      },
    );
  };

  return (
    <section className="hero">
      <div className="hero-body">
        <div className="container">
          <h1 className="title">Login</h1>
          <Formik
            initialValues={{
              email: '',
              password: '',
            }}
            validationSchema={Yup.object().shape({
              email: Yup.string().email('Please provide your email address.'),
              password: Yup.string().required('Please provide your password'),
            })}
            onSubmit={handleSubmit}
          >
            {props => {
              const {
                values,
                touched,
                errors,
                dirty,
                isSubmitting,
                handleChange,
                handleBlur,
                handleSubmit,
                handleReset,
              } = props;
              return (
                <form onSubmit={handleSubmit}>
                  <TextField
                    name="email"
                    label="Email Address"
                    placeholder="Enter your email address"
                    values={values}
                    touched={touched}
                    errors={errors}
                    handleChange={handleChange}
                    handleBlur={handleBlur}
                    icon="envelope"
                  />

                  <TextField
                    name="password"
                    label="Password"
                    type="password"
                    placeholder="Enter your password."
                    values={values}
                    touched={touched}
                    errors={errors}
                    handleChange={handleChange}
                    handleBlur={handleBlur}
                    icon="lock"
                  />

                  <div className="field is-grouped">
                    <div className="control">
                      <button
                        className="button is-link"
                        type="submit"
                        disabled={isSubmitting}
                      >
                        Login
                      </button>
                    </div>
                    <div className="control">
                      <Link to="/sign_up" className="button is-text">
                        Sign Up
                      </Link>
                    </div>
                  </div>
                </form>
              );
            }}
          </Formik>
        </div>
      </div>
    </section>
  );
};
