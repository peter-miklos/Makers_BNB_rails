class Spaces extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      availableSpaces: props.spaces,
      searchDate: props.search_date
    }
  }

  handleHeader() {
    if (this.searchDate)
      return "Available spaces on `this.search_date`"
    else
      return "Available spaces"
  }

  handleSpaceList() {
    if (this.state.availableSpaces.length === 0)
      return "No spaces found"
    else {
      return (
        <table className="spaceListTable mdl-js-data-table mdl-shadow--2dp">
          <thead>
            <tr>
              <th>#</th>
              <th className="mdl-data-table__cell--non-numeric">Name</th>
              <th className="mdl-data-table__cell--non-numeric">Price</th>
              <th className="mdl-data-table__cell--non-numeric">Description</th>
            </tr>
          </thead>
          <tbody>
            { this.handleSpaceListContent() }
          </tbody>
        </table>
      )
    }
  }

  handleSpaceListContent() {
    return this.state.availableSpaces.map(function(space, index) {
      return React.createElement(Space, {
        key: space.id,
        space: space,
        index: index
      })
    });
  }

  render() {
    return (
      <div className="Spaces">
        <h4> { this.handleHeader() } </h4>
        <div className="mdl-grid">
          <form acceptCharset="UTF-8" action="/spaces" method="get" id="search_date_form">
            <input name="utf8" type="hidden" value="&#x2713;" />
            <input name="authenticity_token" type="hidden" value="J7CBxfHalt49OSHp27hblqK20c9PgwJ108nDHX/8Cts=" />
            <input type="date" name="search_date" className="searchBox" id="search_date_field" value={this.state.searchDate ? this.state.searchDate : ""} required />
            <button type="submit" className="mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--accent" id="space_search_button">Search</button>
            <span> </span><a href="/spaces?filter=all">Show all</a>
          </form>
        </div>
        <div className="spaceListContent">
          { this.handleSpaceList() }
        </div>
      </div>
    )
  }
}




// var Spaces = React.createClass({
//   handleHeader: function() {
//
//   },
//   getInitialState: function() {
//     return {allSpaces: this.spaces}
//   },
//   getDefaultProps: function() {
//     return {allSpaces: []}
//   },
//   render: function() {
//    return (
//      <div className="Spaces">
//        <h4>Available spaces</h4>
//      </div>
//    );
//   }
// })
