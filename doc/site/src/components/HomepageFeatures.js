import React from 'react';
import clsx from 'clsx';
import styles from './HomepageFeatures.module.css';

const FeatureList = [
  {
    title: 'Modular',
    description: (
      <>
        Steward is a modular system that allows you to build a minimal API or larger server-side applications.
      </>
    ),
  },
  {
    title: 'Built in DI',
    description: (
      <>
        Steward has a lightweight DI implementation built into the framework and, if you need something more, its possible to roll your own solution, too!
      </>
    ),
  },
  {
    title: 'Reflection Supported',
    description: (
      <>
        Steward uses Reflection for some of it's modules. We're aware that this is often a double-edged sword, but we're committed to covering our reflection paths extremely well so that you can have peace of mind writing clean, simple code and knowing that the framework can handle it.
      </>
    ),
  },
];

function Feature({title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
