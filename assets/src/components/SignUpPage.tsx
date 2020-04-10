import React from 'react';
import gql from 'graphql-tag';
import { useMutation } from '@apollo/react-hooks';
import { Formik } from 'formik';
import * as Yup from 'yup';

import { TextField } from './common/TextField';
import { Link } from 'react-router-dom';
import { transformGraphQLErrors } from './common/utils';

const REGISTER_ACCOUNT = gql`
  mutation(
    $callsign: String!
    $displayName: String!
    $email: String!
    $password: String!
    $passwordConfirmation: String!
  ) {
    registerUser(
      callsign: $callsign
      displayName: $displayName
      email: $email
      password: $password
      passwordConfirmation: $passwordConfirmation
    ) {
      id
      email
    }
  }
`;

export const SignUpPage = () => {
  const [registerUser, { data, loading }] = useMutation(REGISTER_ACCOUNT);
  const handleSubmit = (values, actions) => {
    return registerUser({
      variables: {
        email: values.email,
        callsign: values.callsign,
        displayName: values.displayName,
        password: values.password,
        passwordConfirmation: values.passwordConfirmation,
      },
    }).then(
      ({ data }) => {
        const token = data.authenticateUser.token;
        console.log('result of registerUser', data);
        localStorage.setItem('WSPRHUB_TOKEN', token);
        actions.setSubmitting(false);
      },
      result => {
        actions.setErrors(transformGraphQLErrors(result.graphQLErrors));
        actions.setSubmitting(false);
      },
    );
  };
  return (
    <section className="hero">
      <div className="hero-body">
        <div className="container">
          <h1 className="title">Sign Up</h1>
          <Formik
            initialValues={{
              email: '',
              displayName: '',
              callsign: '',
              password: '',
              passwordConfirmation: '',
            }}
            onSubmit={handleSubmit}
            validationSchema={Yup.object().shape({
              email: Yup.string()
                .email('A valid email address is required.')
                .required('A valid email address is required.'),
              displayName: Yup.string().required(
                'You must provide your full name.',
              ),
              callsign: Yup.string().required(
                'You must provide your amateur radio callsign.',
              ),
              password: Yup.string().required('A password is required.'),
              passwordConfirmation: Yup.string()
                .oneOf([Yup.ref('password'), null], 'Passwords must match.')
                .required('You must confirm your password.'),
            })}
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
                    name="displayName"
                    label="Full name"
                    placeholder="Enter your full name."
                    values={values}
                    touched={touched}
                    errors={errors}
                    handleChange={handleChange}
                    handleBlur={handleBlur}
                    icon="user"
                  />

                  <TextField
                    name="callsign"
                    label="Callsign"
                    placeholder="Enter your amateur radio callsign."
                    values={values}
                    touched={touched}
                    errors={errors}
                    handleChange={handleChange}
                    handleBlur={handleBlur}
                    icon="id-card"
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

                  <TextField
                    name="passwordConfirmation"
                    label="Password Confirmation"
                    type="password"
                    placeholder="Confirm your password."
                    values={values}
                    touched={touched}
                    errors={errors}
                    handleChange={handleChange}
                    handleBlur={handleBlur}
                    icon="lock"
                  />

                  <div className="field">
                    <div className="control">
                      <label className="checkbox">
                        <input type="checkbox" /> I agree to the{' '}
                        <a href="#">terms and conditions</a>
                      </label>
                    </div>
                  </div>

                  <div className="field is-grouped">
                    <div className="control">
                      <button
                        className="button is-link"
                        type="submit"
                        disabled={isSubmitting}
                      >
                        Sign Up
                      </button>
                    </div>
                    <div className="control">
                      <Link to="/login" className="button is-text">
                        Login
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
