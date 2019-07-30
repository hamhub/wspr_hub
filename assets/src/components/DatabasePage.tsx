import React, { Component } from 'react';
import { Query } from 'react-apollo';
import { gql } from 'apollo-boost';
import moment from 'moment';

const friendlydBm = (dbm: number) => {
  const mW = Math.pow(10, dbm / 10);

  return mW < 1000 ? `${Math.round(mW)} mW` : `${Math.round(mW / 1000)} W`;
};

const bands = gql`
  query {
    bands {
      name
    }
  }
`;

const searchSpots = gql`
  query SpotSearch(
    $callsign: String
    $reporter: String
    $timeframe: String
    $band: String
    $orderBy: String
    $orderDir: String
    $limit: Int
    $minKm: Int
    $maxKm: Int
    $startDt: DateTime
    $endDt: DateTime
  ) {
    searchSpots(
      callsign: $callsign
      reporter: $reporter
      timeframe: $timeframe
      band: $band
      limit: $limit
      orderBy: $orderBy
      orderDir: $orderDir
      minKm: $minKm
      maxKm: $maxKm
      startDt: $startDt
      endDt: $endDt
    ) {
      id
      spotDt
      callsign
      frequency
      band
      snr
      drift
      grid
      power
      reporter
      reporterGrid
      distance
      azimuth
    }
  }
`;
export class DatabasePage extends Component {
  constructor(props) {
    super(props);

    this.state = {
      callsignInput: '',
      reporterInput: '',
      timeframeInput: 'month',
      limitInput: 50,
      bandInput: '',

      callsign: '',
      reporter: '',
      timeframe: 'month',
      limit: 50,
      band: '',
    };
  }

  handleSubmit = e => {
    e.preventDefault();

    this.setState({
      callsign: this.state.callsignInput,
      reporter: this.state.reporterInput,
      timeframe: this.state.timeframeInput,
      band: this.state.bandInput,
      limit: parseInt(this.state.limitInput),
    });
  };

  handleCallsign = e => this.setState({ callsignInput: e.target.value });
  handleReporter = e => this.setState({ reporterInput: e.target.value });
  handleTimeframe = e => this.setState({ timeframeInput: e.target.value });
  handleBand = e => this.setState({ bandInput: e.target.value });
  handleLimit = e => this.setState({ limitInput: e.target.value });

  render() {
    return (
      <Query query={bands}>
        {({ loading: bandLoading, error: bandError, data: bandData }) => {
          return bandLoading || bandError ? (
            <div />
          ) : (
            <Query
              query={searchSpots}
              variables={{
                callsign: this.state.callsign,
                reporter: this.state.reporter,
                timeframe: this.state.timeframe,
                band: this.state.band,
                limit: this.state.limit,
              }}
            >
              {({ loading, error, data }) => {
                return loading ? (
                  <div>Loading spot data.</div>
                ) : error ? (
                  <div>
                    There was a problem retrieving spot data:
                    <pre>{JSON.stringify(error)}</pre>
                  </div>
                ) : (
                  <div className="columns">
                    <div className="column" style={{ maxWidth: '15em' }}>
                      <section className="section">
                        <div className="container">
                          <aside className="menu">
                            <p className="menu-label">Search Criteria</p>
                            <form onSubmit={this.handleSubmit}>
                              <div className="field">
                                <label className="label">Band</label>
                                <div className="select is-fullwidth">
                                  <select
                                    value={this.state.bandInput}
                                    onChange={this.handleBand}
                                  >
                                    <option value="">Any</option>
                                    {bandData.bands.map(b => (
                                      <option key={b.name} value={b.name}>
                                        {b.name}
                                      </option>
                                    ))}
                                  </select>
                                </div>
                              </div>

                              <div className="field">
                                <label className="label">Callsign</label>
                                <div className="control">
                                  <input
                                    className="input"
                                    type="text"
                                    placeholder="Seen callsign"
                                    value={this.state.callsignInput}
                                    onChange={this.handleCallsign}
                                  />
                                </div>
                              </div>

                              <div className="field">
                                <label className="label">Reporter</label>
                                <div className="control">
                                  <input
                                    className="input"
                                    type="text"
                                    placeholder="Reporter callsign"
                                    value={this.state.reporterInput}
                                    onChange={this.handleReporter}
                                  />
                                </div>
                              </div>

                              <div className="field">
                                <label className="label">Timeframe</label>
                                <div className="select is-fullwidth">
                                  <select
                                    value={this.state.timeframeInput}
                                    onChange={this.handleTimeframe}
                                  >
                                    <option value="hour">Previous hour</option>
                                    <option value="day">
                                      Previous 24 hours
                                    </option>
                                    <option value="week">Previous week</option>
                                    <option value="month">
                                      Previous month
                                    </option>
                                  </select>
                                </div>
                              </div>

                              <div className="field">
                                <label className="label">Limit</label>
                                <div className="select is-fullwidth">
                                  <select
                                    value={this.state.limitInput}
                                    onChange={this.handleLimit}
                                  >
                                    <option value={50}>50</option>
                                    <option value={100}>100</option>
                                    <option value={500}>500</option>
                                    <option value={1000}>1000</option>
                                  </select>
                                </div>
                              </div>

                              <button
                                type="submit"
                                className="button is-primary"
                              >
                                Apply
                              </button>
                            </form>
                          </aside>
                        </div>
                      </section>
                    </div>
                    <div className="column">
                      <section className="section">
                        <div className="container">
                          <h1 className="title">WSPR Database</h1>
                          <table className="table is-striped is-narrow is-hoverable is-fullwidth">
                            <thead>
                              <tr>
                                <th>Spot Date</th>
                                <th>Callsign</th>
                                <th>Frequency</th>
                                <th>Band</th>
                                <th>SNR</th>
                                <th>Drift</th>
                                <th>Grid</th>
                                <th>Power</th>
                                <th>Reporter</th>
                                <th>Reporter Grid</th>
                                <th>Distance</th>
                                <th>Azimuth</th>
                              </tr>
                            </thead>
                            <tbody>
                              {data.searchSpots.map(spot => (
                                <tr key={spot.id}>
                                  <td>
                                    {moment(spot.spotDt).format(
                                      'YYYY/MM/DD HH:mm:ss',
                                    )}
                                  </td>
                                  <td>{spot.callsign}</td>
                                  <td>{spot.frequency}</td>
                                  <td>{spot.band}</td>
                                  <td>{spot.snr}</td>
                                  <td>{spot.drift}</td>
                                  <td>{spot.grid}</td>
                                  <td>{friendlydBm(spot.power)}</td>
                                  <td>{spot.reporter}</td>
                                  <td>{spot.reporterGrid}</td>
                                  <td>{spot.distance}</td>
                                  <td>{spot.azimuth}</td>
                                </tr>
                              ))}
                            </tbody>
                          </table>
                          <button className="button">
                            <span className="fa fa-refresh" />
                            Buttons!
                          </button>
                        </div>
                      </section>
                    </div>
                  </div>
                );
              }}
            </Query>
          );
        }}
      </Query>
    );
  }
}
