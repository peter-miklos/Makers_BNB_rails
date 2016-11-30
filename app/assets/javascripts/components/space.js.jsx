class Space extends React.Component {
  render() {
    return (
      <tr>
        <td className="mdl-data-table__cell--non-numeric">{this.props.index + 1}</td>
        <td className="mdl-data-table__cell--non-numeric"><a href={`spaces/${this.props.space.id }?date=${this.props.date}`}>{ this.props.space.name }</a></td>
        <td className="mdl-data-table__cell--non-numeric">{this.props.space.price}</td>
        <td className="mdl-data-table__cell--non-numeric">{this.props.space.description}</td>
      </tr>
    )
  }
}
