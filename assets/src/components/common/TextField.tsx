import React from 'react';

export const TextField = props => (
  <div className="field">
    <label className="label">{props.label}</label>
    <div className="control has-icons-left has-icons-right">
      <input
        className={
          props.errors[props.name] && props.touched[props.name]
            ? 'input is-danger'
            : 'input'
        }
        type={props.type || 'text'}
        name={props.name}
        placeholder={props.placeholder}
        value={props.values[props.name]}
        onChange={props.handleChange}
        onBlur={props.handleBlur}
      />
      {props.icon && (
        <span className="icon is-small is-left">
          <i className={`fa fa-${props.icon}`}></i>
        </span>
      )}
    </div>
    {props.errors[props.name] && props.touched[props.name] && (
      <p className="help is-danger">{props.errors[props.name]}</p>
    )}
  </div>
);
