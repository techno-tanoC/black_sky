import React, {Component} from 'react'
import request from 'superagent'

import styles from './styles.css'

export default ({id, name, total, size}) => {
  const percent = Math.floor(size / total * 100)

  const deleteItem = () => {
    request
      .post("/cancel")
      .send({key: id})
      .end(() => {})
  }

  return (
    <div className={styles.card}>
      <div className={styles.name}>{name}</div>
      <div>
        {percent}%, total: {total.toLocaleString()}, size: {size.toLocaleString()}
        <button onClick={deleteItem}>cancel</button>
      </div>
    </div>
  )
}
