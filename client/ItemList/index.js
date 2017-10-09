import React, {Component} from 'react'
import request from 'superagent'

import Item from '../Item'

export default class ItemList extends Component {
  constructor(props) {
    super(props)
    this.state = {data: []}
    this.loadData = this.loadData.bind(this)
  }

  loadData() {
    request
      .get("/index")
      .end((err, res) => {
        const arr = JSON.parse(res.text)
        this.setState({data: arr})
      })
  }

  componentDidMount() {
    this.loadData()
    setInterval(this.loadData, 1000)
  }

  render() {
    return (
      <div>
        {this.state.data.map(item => (
          <Item key={item.id} {...item} />
        ))}
      </div>
    )
  }
}
