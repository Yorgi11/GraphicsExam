using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : MonoBehaviour
{
    [SerializeField] private float speed;
    [SerializeField] private Transform[] positions;

    private Vector3 currentPos;
    private Vector3 dir;

    private Rigidbody rb;
    private void Start()
    {
        rb = GetComponent<Rigidbody>();
        currentPos = positions[0].position;
    }
    void Update()
    {
        if (Vector3.Distance(transform.position, currentPos) <= 0.25f) SetCurrentPos();
        Debug.Log(Vector3.Distance(transform.position, currentPos));
        if (rb.velocity.magnitude >= speed) rb.velocity = rb.velocity.normalized * speed;
        dir = (currentPos - transform.position).normalized;
        dir = new Vector3(dir.x, 0f, dir.z);
    }
    private void FixedUpdate()
    {
        rb.AddForce(dir * speed);
    }
    private void SetCurrentPos()
    {
        currentPos = positions[(int)Random.Range(0, positions.Length - 1)].position;
        Debug.Log("SEPOS");
    }
}
