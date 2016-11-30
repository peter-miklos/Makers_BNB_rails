class Spaces extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      availableSpaces: props.spaces,
      searchDate: props.search_date ? props.search_date : ""
    };
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleClick = this.handleClick.bind(this);
  }

  handleHeader() {
    if (this.state.searchDate)
      return `Available spaces on ${this.state.searchDate}`
    else
      return "Available spaces"
  }

  handleSpaceList(spaces) {
    if (spaces.length === 0)
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
            { this.handleSpaceListContent(spaces) }
          </tbody>
        </table>
      )
    }
  }

  handleSpaceListContent(spaces) {
    return spaces.map(function(space, index) {
      return React.createElement(Space, {
        key: space.id,
        space: space,
        index: index
      })
    });
  }

  handleChange(event, spaces) {
    this.setState({
      searchDate: event.target.value,
      availableSpaces: spaces
    })
  }

  handleSubmit(event) {
    event.preventDefault();
    let spaces = this.state.availableSpaces.filter(function(e) { return e.price < 100 })
    this.handleChange(event, spaces);
  }

  handleClick(event) {
    event.preventDefault();
    this.setState({
      availableSpaces: this.props.spaces,
      searchDate: ""
    })
  }

  render() {
    return (
      <div className="Spaces">
        <h4> { this.handleHeader() } </h4>
        <div className="mdl-grid">
          <form acceptCharset="UTF-8" id="search_date_form" onSubmit={this.handleSubmit}>
            Filter for date:
            <input type="date" name="search_date" className="searchBox" id="search_date_field" value={this.state.searchDate} onChange={this.handleSubmit} required />
            <span> </span><a onClick={this.handleClick}>Show all</a>
          </form>
        </div>
        <div className="spaceListContent">
          { this.handleSpaceList(this.state.availableSpaces) }
        </div>
      </div>
    )
  }
}
